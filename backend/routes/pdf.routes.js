const express = require('express');
const router = express.Router();
const PdfController = require('../controllers/PdfController');

router.post('/upload', PdfController.uploadAndExplainPdf);

module.exports = router;
