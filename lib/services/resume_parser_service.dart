import 'dart:io';
import 'dart:typed_data';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'pdf_ocr_service.dart';

class ResumeParserService {
  static const supportedExtensions = ['pdf', 'docx'];
  static const _minTextLength = 50;

  final _ocrService = PdfOcrService();

  Future<String> parseFile(PlatformFile file) async {
    final name = file.name.toLowerCase();

    if (name.endsWith('.pdf')) {
      return _parsePdf(file);
    }
    if (name.endsWith('.docx')) {
      return _parseDocx(file);
    }

    throw Exception('Unsupported format. Please upload a PDF or DOCX file.');
  }

  Future<Uint8List> _readBytes(PlatformFile file) async {
    if (file.bytes != null) return file.bytes!;
    if (file.path != null) return File(file.path!).readAsBytes();
    throw Exception('Could not read the file. Please try again.');
  }

  Future<String> _parsePdf(PlatformFile file) async {
    final bytes = await _readBytes(file);

    final document = PdfDocument(inputBytes: bytes);
    try {
      final text = PdfTextExtractor(document).extractText().trim();
      if (text.length >= _minTextLength) {
        return _normalize(text);
      }
    } finally {
      document.dispose();
    }

    final ocrText = await _ocrService.extractText(bytes);
    return _normalize(ocrText);
  }

  Future<String> _parseDocx(PlatformFile file) async {
    final bytes = await _readBytes(file);
    final text = docxToText(bytes);
    return _normalize(text);
  }

  String _normalize(String text) {
    final normalized = text
        .replaceAll('\r\n', '\n')
        .split('\n')
        .map((line) => line.trimRight())
        .join('\n')
        .trim();

    if (normalized.isEmpty) {
      throw Exception(
        'No text found in this file. Try a clearer PDF or paste the text manually.',
      );
    }

    return normalized;
  }
}
