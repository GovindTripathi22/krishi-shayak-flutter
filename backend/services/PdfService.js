const Document = require('../models/Document');
const OcrResult = require('../models/OcrResult');
const DocumentAnalysis = require('../models/DocumentAnalysis');
const GovernmentScheme = require('../models/GovernmentScheme');
const OCRService = require('./OCRService');
const GeminiService = require('./GeminiService');

const asStrings = (value) => Array.isArray(value) ? value.filter((item) => typeof item === 'string').map((item) => item.trim()).filter(Boolean).slice(0, 20) : [];
class PdfService {
  async processDocument(document) {
    const existing = await DocumentAnalysis.findOne({ documentId: document._id }).lean();
    if (existing) return { document, ocr: await OcrResult.findOne({ documentId: document._id }).lean(), analysis: existing, cached: true };
    document.processingStatus = 'processing'; await document.save();
    try {
      const ocrData = await OCRService.extractTextFromImageOrPdf(document.storagePath, document.mimeType);
      const ocr = await OcrResult.findOneAndUpdate({ documentId: document._id }, { $set: { documentId: document._id, extractedText: ocrData.extractedText, pageCount: ocrData.pageCount, confidenceScore: ocrData.confidenceScore, engine: ocrData.engine, status: 'completed' } }, { new: true, upsert: true, runValidators: true });
      const analysis = await this.analyseExtractedText(document, ocrData.extractedText);
      document.processingStatus = 'completed'; document.extractedTextPreview = ocrData.extractedText.slice(0, 500); await document.save();
      return { document, ocr: ocr.toObject(), analysis, cached: false };
    } catch (error) { document.processingStatus = 'failed'; await document.save(); throw error; }
  }
  async analyseExtractedText(document, extractedText) {
    const existing = await DocumentAnalysis.findOne({ documentId: document._id }).lean(); if (existing) return existing;
    const relevantSchemes = await GovernmentScheme.find({ $text: { $search: extractedText.slice(0, 2500) }, status: 'Active' }).limit(5).select('name').lean().catch(() => []);
    const prompt = `Analyse only the extracted text below from a farmer document. Do not invent facts. Return valid JSON with exactly: summary (string), importantPoints (string array), eligibilityInformation (string array), requiredDocuments (string array), deadlines (string array), warnings (string array), recommendations (string array). If a field is absent from the text, return an empty array or say unavailable in summary.\n\nEXTRACTED TEXT:\n${extractedText.slice(0, 18000)}`;
    const generated = await GeminiService.generateResponse(prompt);
    let data;
    try { data = JSON.parse(generated.text.replace(/^```json\s*|\s*```$/g, '').trim()); }
    catch (_) { const error = new Error('AI analysis returned an invalid structured response.'); error.statusCode = 503; throw error; }
    if (typeof data.summary !== 'string' || !data.summary.trim()) { const error = new Error('AI analysis did not contain a summary.'); error.statusCode = 503; throw error; }
    const analysis = await DocumentAnalysis.create({ documentId: document._id, summary: data.summary.trim(), importantPoints: asStrings(data.importantPoints), eligibilityInformation: asStrings(data.eligibilityInformation), requiredDocuments: asStrings(data.requiredDocuments), deadlines: asStrings(data.deadlines), warnings: asStrings(data.warnings), recommendations: asStrings(data.recommendations), schemeReferences: relevantSchemes.map((scheme) => ({ schemeId: scheme._id, name: scheme.name })), model: GeminiService.model });
    return analysis.toObject();
  }
}
module.exports = new PdfService();
