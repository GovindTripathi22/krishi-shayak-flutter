const fs = require('fs/promises');
const path = require('path');
const crypto = require('crypto');
const mongoose = require('mongoose');
const Document = require('../models/Document');
const OcrResult = require('../models/OcrResult');
const DocumentAnalysis = require('../models/DocumentAnalysis');
const PdfService = require('../services/PdfService');

const present = (document, ocr, analysis) => ({ id: document._id.toString(), fileName: document.fileName, fileType: document.fileType, fileSizeBytes: document.fileSizeBytes, uploadDate: document.createdAt, status: document.processingStatus, language: document.language, extractedTextPreview: ocr?.extractedText?.slice(0, 2000) || document.extractedTextPreview, pageCount: ocr?.pageCount || 0, summary: analysis?.summary || null, importantPoints: analysis?.importantPoints || [], eligibilityInformation: analysis?.eligibilityInformation || [], requiredDocuments: analysis?.requiredDocuments || [], deadlines: analysis?.deadlines || [], warnings: analysis?.warnings || [], recommendations: analysis?.recommendations || [], schemeReferences: analysis?.schemeReferences || [] });
class PdfController {
  static async uploadAndExplainPdf(req, res, next) {
    try {
      if (!req.file) return res.status(400).json({ success: false, message: 'Attach a PDF or image file.' });
      const hash = crypto.createHash('sha256').update(await fs.readFile(req.file.path)).digest('hex');
      let document = await Document.findOne({ userId: req.user.id, contentHash: hash }).select('+storagePath');
      if (!document) document = await Document.create({ userId: req.user.id, fileName: path.basename(req.file.originalname).replace(/[^a-zA-Z0-9._ -]/g, '_').slice(0, 160), fileType: req.file.mimetype === 'application/pdf' ? 'pdf' : req.file.mimetype.split('/')[1], fileUrl: `documents/${req.file.filename}`, storagePath: req.file.path, fileSizeBytes: req.file.size, mimeType: req.file.mimetype, contentHash: hash, language: req.body.language || 'en' });
      else await fs.rm(req.file.path, { force: true });
      const result = await PdfService.processDocument(document);
      res.status(201).json({ success: true, data: present(result.document, result.ocr, result.analysis), cached: result.cached });
    } catch (error) { next(error); }
  }
  static async analyze(req, res, next) { try { if (!mongoose.isValidObjectId(req.body.documentId)) return res.status(400).json({ success: false, message: 'A valid documentId is required.' }); const document = await Document.findOne({ _id: req.body.documentId, userId: req.user.id }).select('+storagePath'); if (!document) return res.status(404).json({ success: false, message: 'Document not found.' }); const result = await PdfService.processDocument(document); res.json({ success: true, data: present(result.document, result.ocr, result.analysis), cached: result.cached }); } catch (error) { next(error); } }
  static async history(req, res, next) { try { const query = { userId: req.user.id }; if (req.query.q?.trim()) query.$text = { $search: req.query.q.trim().slice(0, 120) }; const documents = await Document.find(query).sort({ createdAt: -1 }).limit(50).lean(); const ids = documents.map((document) => document._id); const [ocrs, analyses] = await Promise.all([OcrResult.find({ documentId: { $in: ids } }).lean(), DocumentAnalysis.find({ documentId: { $in: ids } }).lean()]); const ocrById = new Map(ocrs.map((ocr) => [ocr.documentId.toString(), ocr])); const analysisById = new Map(analyses.map((analysis) => [analysis.documentId.toString(), analysis])); res.json({ success: true, data: documents.map((document) => present(document, ocrById.get(document._id.toString()), analysisById.get(document._id.toString()))) }); } catch (error) { next(error); } }
  static async getById(req, res, next) { try { if (!mongoose.isValidObjectId(req.params.id)) return res.status(400).json({ success: false, message: 'Invalid document ID.' }); const document = await Document.findOne({ _id: req.params.id, userId: req.user.id }).lean(); if (!document) return res.status(404).json({ success: false, message: 'Document not found.' }); const [ocr, analysis] = await Promise.all([OcrResult.findOne({ documentId: document._id }).lean(), DocumentAnalysis.findOne({ documentId: document._id }).lean()]); res.json({ success: true, data: present(document, ocr, analysis) }); } catch (error) { next(error); } }
  static async delete(req, res, next) { try { if (!mongoose.isValidObjectId(req.params.id)) return res.status(400).json({ success: false, message: 'Invalid document ID.' }); const document = await Document.findOneAndDelete({ _id: req.params.id, userId: req.user.id }).select('+storagePath'); if (!document) return res.status(404).json({ success: false, message: 'Document not found.' }); await Promise.all([OcrResult.deleteOne({ documentId: document._id }), DocumentAnalysis.deleteOne({ documentId: document._id }), fs.rm(document.storagePath, { force: true })]); res.status(204).send(); } catch (error) { next(error); } }
}
module.exports = PdfController;
