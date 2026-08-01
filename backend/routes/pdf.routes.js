const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const PdfController = require('../controllers/PdfController');
const { protect } = require('../middleware/auth.middleware');
const router = express.Router();
const storageDirectory = path.resolve(process.env.DOCUMENT_STORAGE_PATH || path.join(__dirname, '..', 'storage', 'documents'));
const storage = multer.diskStorage({ destination: (_, __, callback) => { fs.mkdirSync(storageDirectory, { recursive: true }); callback(null, storageDirectory); }, filename: (_, file, callback) => callback(null, `${crypto.randomUUID()}${path.extname(file.originalname).toLowerCase()}`) });
const upload = multer({ storage, limits: { fileSize: 10 * 1024 * 1024, files: 1 }, fileFilter: (_, file, callback) => callback(null, ['application/pdf', 'image/jpeg', 'image/png'].includes(file.mimetype)) });
router.use(protect);
router.post('/upload', (req, res, next) => upload.single('file')(req, res, (error) => {
  if (error) { error.statusCode = 400; error.message = error.code === 'LIMIT_FILE_SIZE' ? 'File must not exceed 10 MB.' : 'Only PDF, JPEG, and PNG uploads are supported.'; return next(error); }
  return PdfController.uploadAndExplainPdf(req, res, next);
}));
router.post('/analyze', PdfController.analyze);
router.get('/history', PdfController.history);
router.get('/:id', PdfController.getById);
router.delete('/:id', PdfController.delete);
module.exports = router;
