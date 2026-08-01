const { execFile } = require('child_process');
const { promisify } = require('util');
const fs = require('fs/promises');
const path = require('path');
const os = require('os');
const { createWorker } = require('tesseract.js');
const exec = promisify(execFile);

class OCRService {
  async extractTextFromImageOrPdf(filePath, mimeType) {
    if (mimeType === 'application/pdf') return this.extractPdf(filePath);
    return this.extractImage(filePath);
  }
  async extractImage(filePath) {
    const worker = await createWorker('eng');
    try { const result = await worker.recognize(filePath); const text = result.data.text.trim(); if (!text) throw new Error('No readable text was found in this image.'); return { extractedText: text, pageCount: 1, confidenceScore: Number(result.data.confidence || 0) / 100, engine: 'tesseract' }; }
    finally { await worker.terminate(); }
  }
  async extractPdf(filePath) {
    const textPath = `${filePath}.txt`;
    try { await exec(process.env.PDFTOTEXT_PATH || 'pdftotext', ['-layout', filePath, textPath], { timeout: 30000 }); const text = (await fs.readFile(textPath, 'utf8')).trim(); if (text) return { extractedText: text, pageCount: Math.max(1, (text.match(/\f/g) || []).length + 1), confidenceScore: 1, engine: 'pdftotext' }; }
    catch (_) { /* scanned PDFs proceed to OCR */ }
    finally { await fs.rm(textPath, { force: true }); }
    const outputDirectory = await fs.mkdtemp(path.join(os.tmpdir(), 'krishi-pdf-'));
    try {
      const prefix = path.join(outputDirectory, 'page');
      await exec(process.env.PDFTOPPM_PATH || 'pdftoppm', ['-png', '-r', '200', filePath, prefix], { timeout: 60000 });
      const pages = (await fs.readdir(outputDirectory)).filter((name) => name.endsWith('.png')).sort();
      if (!pages.length) throw new Error('The PDF could not be read.');
      const results = await Promise.all(pages.map((page) => this.extractImage(path.join(outputDirectory, page))));
      const extractedText = results.map((result) => result.extractedText).filter(Boolean).join('\n\n').trim();
      if (!extractedText) throw new Error('No readable text was found in this PDF.');
      return { extractedText, pageCount: pages.length, confidenceScore: results.reduce((sum, result) => sum + result.confidenceScore, 0) / results.length, engine: 'pdftoppm+tesseract' };
    } finally { await fs.rm(outputDirectory, { recursive: true, force: true }); }
  }
}
module.exports = new OCRService();
