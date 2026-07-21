import 'dart:io';
import 'dart:typed_data';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class PdfOcrService {
  Future<String> extractText(Uint8List bytes) async {
    final document = await PdfDocument.openData(bytes);
    final recognizer = TextRecognizer();
    final buffer = StringBuffer();

    try {
      for (var i = 1; i <= document.pagesCount; i++) {
        final page = await document.getPage(i);
        try {
          final image = await page.render(
            width: page.width * 2,
            height: page.height * 2,
            format: PdfPageImageFormat.png,
          );

          if (image == null) continue;

          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/ocr_page_$i.png');
          await tempFile.writeAsBytes(image.bytes);

          try {
            final inputImage = InputImage.fromFilePath(tempFile.path);
            final result = await recognizer.processImage(inputImage);
            if (result.text.trim().isNotEmpty) {
              if (buffer.isNotEmpty) buffer.writeln();
              buffer.write(result.text.trim());
            }
          } finally {
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          }
        } finally {
          await page.close();
        }
      }
    } finally {
      await document.close();
      await recognizer.close();
    }

    return buffer.toString().trim();
  }
}
