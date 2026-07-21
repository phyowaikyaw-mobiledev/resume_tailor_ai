import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportService {
  static const _maxChunkLength = 100;

  Future<void> exportResume(String text) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(48),
        build: (context) => _buildParagraphs(text),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  List<pw.Widget> _buildParagraphs(String text) {
    final widgets = <pw.Widget>[];

    for (final line in text.split('\n')) {
      if (line.trim().isEmpty) {
        widgets.add(pw.SizedBox(height: 8));
        continue;
      }

      final isSectionHeader = _isSectionHeader(line);
      widgets.add(
        pw.Paragraph(
          text: _wrapLongLine(line),
          style: pw.TextStyle(
            fontSize: isSectionHeader ? 12 : 11,
            lineSpacing: 2,
            fontWeight: isSectionHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      );
    }

    return widgets;
  }

  bool _isSectionHeader(String line) {
    final trimmed = line.trim().replaceAll(':', '');
    if (trimmed.length > 40) return false;
    return trimmed == trimmed.toUpperCase() &&
        RegExp(r'^[A-Z\s]+$').hasMatch(trimmed);
  }

  String _wrapLongLine(String line) {
    if (line.length <= _maxChunkLength || line.contains(' ')) {
      return line;
    }

    final buffer = StringBuffer();
    for (var i = 0; i < line.length; i += _maxChunkLength) {
      if (i > 0) buffer.write('\n');
      buffer.write(line.substring(
        i,
        i + _maxChunkLength > line.length ? line.length : i + _maxChunkLength,
      ));
    }
    return buffer.toString();
  }
}
