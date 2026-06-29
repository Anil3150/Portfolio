import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../data/resume_data.dart';

/// Generates a professional PDF resume and downloads / opens it.
class ResumeService {
  static Future<void> download() async {
    final bytes = await _generatePdf();
    if (kIsWeb) {
      await _downloadWeb(bytes);
    } else {
      await _openMobile(bytes);
    }
  }

  // ─── PDF Generation ──────────────────────────────────────────────────────────
  static Future<Uint8List> _generatePdf() async {
    final doc = PdfDocument();
    doc.pageSettings.margins.all = 36;
    PdfPage page = doc.pages.add();
    final bounds = page.getClientSize();
    final w = bounds.width;

    // ── Fonts ────────────────────────────────────────────────────────────────
    final fontBold   = PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);
    final fontReg    = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final fontSm     = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final fontTitle  = PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold);
    final fontSec    = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    // ── Colors ────────────────────────────────────────────────────────────────
    final primary    = PdfColor(37, 99, 235);   // #2563EB
    final darkGrey   = PdfColor(31, 41, 55);    // #1F2937
    final midGrey    = PdfColor(107, 114, 128); // #6B7280
    final lightGrey  = PdfColor(243, 244, 246); // #F3F4F6

    double y = 0;

    // ── Header block ──────────────────────────────────────────────────────────
    final headerRect = Rect.fromLTWH(0, y, w, 90);
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(primary),
      bounds: headerRect,
    );

    page.graphics.drawString(
      ResumeData.name,
      fontTitle,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(16, y + 14, w - 32, 30),
    );
    page.graphics.drawString(
      'Flutter Developer | Mobile Application Developer',
      PdfStandardFont(PdfFontFamily.helvetica, 11),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(16, y + 44, w - 32, 18),
    );

    // Contact row
    final contactLine =
        '${ResumeData.email}   |   ${ResumeData.phone}   |   ${ResumeData.location}';
    page.graphics.drawString(
      contactLine, fontSm,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(16, y + 66, w - 32, 16),
    );

    y = 106;

    // ─── Helper: check page overflow ──────────────────────────────────────────
    void checkPageBreak([double needed = 40]) {
      if (y + needed > bounds.height) {
        page = doc.pages.add();
        y = 0;
      }
    }

    // ─── Helper: section heading ──────────────────────────────────────────────
    void sectionHeading(String title) {
      checkPageBreak(50);
      page.graphics.drawString(
        title.toUpperCase(), fontSec,
        brush: PdfSolidBrush(primary),
        bounds: Rect.fromLTWH(0, y, w, 18),
      );
      y += 20;
      page.graphics.drawRectangle(
        brush: PdfSolidBrush(primary),
        bounds: Rect.fromLTWH(0, y, w, 1.5),
      );
      y += 8;
    }

    // ─── Helper: body text with wrap & pagination ────────────────────────────
    double textBlock(String text, PdfFont font, {PdfColor? color, double indent = 0, double extraBottom = 4}) {
      checkPageBreak(20);
      final tf = PdfTextElement(
        text: text, font: font,
        brush: PdfSolidBrush(color ?? darkGrey),
        format: PdfStringFormat(wordWrap: PdfWordWrapType.word),
      );
      
      final layoutFormat = PdfLayoutFormat(
        layoutType: PdfLayoutType.paginate,
      );

      final result = tf.draw(
        page: page,
        bounds: Rect.fromLTWH(indent, y, w - indent, 0),
        format: layoutFormat,
      )!;
      
      page = result.page; // Update to the page where drawing ended
      y = result.bounds.bottom + extraBottom;
      return result.bounds.height;
    }

    // ── Professional Summary ──────────────────────────────────────────────────
    sectionHeading('Professional Summary');
    textBlock(ResumeData.summary, fontReg, extraBottom: 14);

    // ── Technical Skills ─────────────────────────────────────────────────────
    sectionHeading('Technical Skills');
    final skillEntries = ResumeData.skills.entries.toList();
    for (final entry in skillEntries) {
      final skills = entry.value.map((s) => s['name'] as String).join(', ');
      textBlock('${entry.key}: ', fontBold, extraBottom: 0);
      y -= 14; // pull up so value is on same line
      final labelW = fontBold.measureString('${entry.key}: ').width + 2;
      textBlock(skills, fontReg, indent: labelW, extraBottom: 6);
    }
    y += 8;

    // ── Professional Experience ───────────────────────────────────────────────
    sectionHeading('Professional Experience');
    for (final exp in ResumeData.experience) {
      // Role + company
      textBlock('${exp['role']} — ${exp['company']}', fontBold, extraBottom: 2);
      textBlock(exp['duration'] as String, fontSm, color: midGrey, extraBottom: 6);
      // Responsibilities
      for (final r in (exp['responsibilities'] as List)) {
        textBlock('• $r', fontReg, indent: 12, extraBottom: 4);
      }
      y += 6;
    }

    // ── Projects ─────────────────────────────────────────────────────────────
    sectionHeading('Projects');
    for (final p in ResumeData.projects) {
      textBlock('${p['title']} — ${p['category']}', fontBold, extraBottom: 2);
      textBlock(p['description'] as String, fontReg, indent: 12, extraBottom: 3);
      final techs = (p['technologies'] as List).join(', ');
      textBlock('Tech: $techs', fontSm, indent: 12, color: midGrey, extraBottom: 8);
    }

    // ── Education ────────────────────────────────────────────────────────────
    sectionHeading('Education');
    for (final edu in ResumeData.education) {
      textBlock(edu['degree'] as String, fontBold, extraBottom: 2);
      textBlock('${edu['college']}  |  ${edu['year']}', fontReg, indent: 12, color: midGrey, extraBottom: 8);
    }

    // ── Achievements ─────────────────────────────────────────────────────────
    sectionHeading('Achievements');
    for (final a in ResumeData.achievements) {
      textBlock('• $a', fontReg, indent: 12, extraBottom: 5);
    }

    // ── Declaration ──────────────────────────────────────────────────────────
    sectionHeading('Declaration');
    textBlock(ResumeData.declaration, fontReg, extraBottom: 14);

    // ── Footer ────────────────────────────────────────────────────────────────
    checkPageBreak(30);
    final footerY = bounds.height - 20;
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(lightGrey),
      bounds: Rect.fromLTWH(0, footerY - 4, w, 24),
    );
    page.graphics.drawString(
      'LinkedIn: ${ResumeData.linkedIn}   |   GitHub: https://github.com/Anil3150',
      fontSm,
      brush: PdfSolidBrush(midGrey),
      bounds: Rect.fromLTWH(8, footerY, w - 16, 16),
    );

    final bytes = Uint8List.fromList(await doc.save());
    doc.dispose();
    return bytes;
  }



  // ─── Web download via anchor click ───────────────────────────────────────────
  static Future<void> _downloadWeb(Uint8List bytes) async {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'Anil_Kumar_Resume.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // ─── Mobile: save to temp dir and open ───────────────────────────────────────
  static Future<void> _openMobile(Uint8List bytes) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/Anil_Kumar_Resume.pdf');
      await file.writeAsBytes(bytes, flush: true);
      await OpenFile.open(file.path);
    } catch (_) {
      // Handle error if needed
    }
  }
}
