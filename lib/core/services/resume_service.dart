import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Rect, Size;
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
    doc.pageSettings.margins.all = 40;
    PdfPage page = doc.pages.add();
    final pageSize = page.getClientSize();
    final w = pageSize.width;

    // ── Fonts ──────────────────────────────────────────────────────────────────
    final fName    = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    final fTitle   = PdfStandardFont(PdfFontFamily.helvetica, 11);
    final fContact = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final fSec     = PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);
    final fBold    = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final fReg     = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final fSm      = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final fSmBold  = PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);

    // ── Colors ─────────────────────────────────────────────────────────────────
    final primary   = PdfColor(37, 99, 235);    // #2563EB
    final darkGrey  = PdfColor(17, 24, 39);     // #111827
    final midGrey   = PdfColor(107, 114, 128);  // #6B7280
    final ruleLine  = PdfColor(209, 213, 219);  // #D1D5DB

    double y = 0;

    // ── State tracking for multi-page ──────────────────────────────────────────
    Size bounds = pageSize;

    void checkPageBreak([double needed = 30]) {
      if (y + needed > bounds.height) {
        page = doc.pages.add();
        bounds = page.getClientSize();
        y = 0;
      }
    }

    // ── Draw horizontal rule ───────────────────────────────────────────────────
    void drawRule({bool isPrimary = false}) {
      final ruleColor = isPrimary ? primary : ruleLine;
      page.graphics.drawRectangle(
        brush: PdfSolidBrush(ruleColor),
        bounds: Rect.fromLTWH(0, y, w, 1),
      );
      y += 5;
    }

    // ── Draw section heading ───────────────────────────────────────────────────
    void sectionHeading(String title) {
      checkPageBreak(50);
      y += 8;
      page.graphics.drawString(
        title.toUpperCase(), fSec,
        brush: PdfSolidBrush(primary),
        bounds: Rect.fromLTWH(0, y, w, 16),
      );
      y += 18;
      drawRule(isPrimary: true);
    }

    // ── Draw wrapping text block with pagination ───────────────────────────────
    void textBlock(
      String text,
      PdfFont font, {
      PdfColor? color,
      double indent = 0,
      double bottomPad = 4,
    }) {
      if (text.trim().isEmpty) return;
      checkPageBreak(16);
      final tf = PdfTextElement(
        text: text,
        font: font,
        brush: PdfSolidBrush(color ?? darkGrey),
        format: PdfStringFormat(wordWrap: PdfWordWrapType.word),
      );
      final result = tf.draw(
        page: page,
        bounds: Rect.fromLTWH(indent, y, w - indent, 0),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
      )!;
      page = result.page;
      bounds = page.getClientSize();
      y = result.bounds.bottom + bottomPad;
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // HEADER
    // ═══════════════════════════════════════════════════════════════════════════
    // Name
    page.graphics.drawString(
      ResumeData.name, fName,
      brush: PdfSolidBrush(primary),
      bounds: Rect.fromLTWH(0, y, w, 26),
    );
    y += 26;

    // Title
    page.graphics.drawString(
      ResumeData.title, fTitle,
      brush: PdfSolidBrush(darkGrey),
      bounds: Rect.fromLTWH(0, y, w, 16),
    );
    y += 16;
    y += 4;

    // Contact line 1: location | phone | email
    final contact1 = '${ResumeData.location}   |   ${ResumeData.phone}   |   ${ResumeData.email}';
    page.graphics.drawString(
      contact1, fContact,
      brush: PdfSolidBrush(midGrey),
      bounds: Rect.fromLTWH(0, y, w, 14),
    );
    y += 14;

    // Contact line 2: LinkedIn | Portfolio
    final contact2 = 'LinkedIn: ${ResumeData.linkedInDisplay}   |   Portfolio: ${ResumeData.portfolioUrl}';
    page.graphics.drawString(
      contact2, fContact,
      brush: PdfSolidBrush(midGrey),
      bounds: Rect.fromLTWH(0, y, w, 14),
    );
    y += 18;

    // Full-width divider under header
    drawRule(isPrimary: true);

    // ═══════════════════════════════════════════════════════════════════════════
    // PROFESSIONAL SUMMARY
    // ═══════════════════════════════════════════════════════════════════════════
    sectionHeading('Professional Summary');
    textBlock(ResumeData.summary, fReg, bottomPad: 2);

    // ═══════════════════════════════════════════════════════════════════════════
    // TECHNICAL SKILLS
    // ═══════════════════════════════════════════════════════════════════════════
    sectionHeading('Technical Skills');
    final skillCategories = {
      'Programming Languages': 'Dart, Java, SQL',
      'Mobile Framework': 'Flutter (SDK 3.x), Dart Null Safety, Cross-Platform Development, Material Design',
      'State Management': 'GetX, BLoC',
      'Architecture': 'Clean Architecture, MVVM, MVC, Repository Pattern, Domain-Driven Design (DDD), SOLID Principles',
      'Backend Integration': 'REST API, Dio, HTTP, JSON Parsing, WebSockets, Socket.IO, Dartz (Functional Error Handling)',
      'Firebase': 'Authentication, Cloud Messaging (FCM) / Push Notifications, Firebase Core',
      'Local Storage': 'SharedPreferences, Flutter Secure Storage, Path Provider',
      'Payment Integration': 'Razorpay, Cashfree, Stripe, WebView Payment Bridge',
      'Authentication': 'JWT, OAuth 2.0, OTP Verification, Google Sign-In, LinkedIn OAuth, Social Login',
      'Mobile Features': 'Deep Linking, Universal Links, Dynamic Links, Google Maps, Geolocation, Camera, Image Picker, QR Scanner, File Upload, Permissions, Push Notifications',
      'Deployment': 'Google Play Store, Apple App Store, Play Console, App Store Connect, TestFlight, Build Flavors, App Signing',
      'Tools': 'Android Studio, VS Code, Xcode, Git, GitHub, Postman, Figma',
      'Methodologies': 'Agile, Scrum, Code Review, Version Control (Git/GitHub)',
    };

    for (final entry in skillCategories.entries) {
      checkPageBreak(16);
      final labelText = '${entry.key}: ';
      final labelW = fSmBold.measureString(labelText).width;
      // Draw label
      page.graphics.drawString(
        labelText, fSmBold,
        brush: PdfSolidBrush(darkGrey),
        bounds: Rect.fromLTWH(0, y, labelW + 4, 14),
      );
      // Draw value wrapping after the label on same line
      final valTf = PdfTextElement(
        text: entry.value,
        font: fSm,
        brush: PdfSolidBrush(midGrey),
        format: PdfStringFormat(wordWrap: PdfWordWrapType.word),
      );
      final valResult = valTf.draw(
        page: page,
        bounds: Rect.fromLTWH(labelW + 4, y, w - labelW - 4, 0),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
      )!;
      page = valResult.page;
      bounds = page.getClientSize();
      y = valResult.bounds.bottom + 3;
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // PROFESSIONAL EXPERIENCE
    // ═══════════════════════════════════════════════════════════════════════════
    sectionHeading('Professional Experience');
    for (final exp in ResumeData.experience) {
      checkPageBreak(50);
      // Role line (bold) + duration (right-aligned)
      final roleText = '${exp['role']} — ${exp['company']}';
      final durText  = exp['duration'] as String;
      final durW     = fSmBold.measureString(durText).width;
      page.graphics.drawString(
        roleText, fBold,
        brush: PdfSolidBrush(darkGrey),
        bounds: Rect.fromLTWH(0, y, w - durW - 4, 14),
      );
      page.graphics.drawString(
        durText, fSmBold,
        brush: PdfSolidBrush(primary),
        bounds: Rect.fromLTWH(w - durW, y, durW, 14),
      );
      y += 15;

      // Tech stack line
      if (exp.containsKey('technologies')) {
        final techLine = (exp['technologies'] as List).join(' • ');
        textBlock(techLine, fSm, color: midGrey, bottomPad: 5);
      }

      // Responsibilities
      for (final r in (exp['responsibilities'] as List)) {
        textBlock('• $r', fReg, indent: 10, bottomPad: 3);
      }
      y += 8;
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // PROJECTS
    // ═══════════════════════════════════════════════════════════════════════════
    sectionHeading('Projects');

    final projects = [
      {
        'title': 'U-Need Business – Logistics & Delivery Platform',
        'company': 'HashStack Solutions',
        'tech': 'Flutter • Dart • GetX • Clean Architecture • Socket.IO • WebSocket • Google Maps SDK • Cashfree • Dio • Dartz',
        'bullets': [
          'Consolidated two separate application contexts (Vendor Business Management and Rider Delivery Operations) into a single optimized Flutter codebase using feature-based Clean Architecture.',
          'Implemented real-time order tracking and dispatch with WebSockets and Google Maps SDK, increasing dispatcher visibility and reducing delivery turnaround time.',
        ],
      },
      {
        'title': 'Bizztiny Marketplace – E-Commerce Application',
        'company': 'HashStack Solutions',
        'tech': 'Flutter • Dart • GetX • Socket.IO • WebView • Google Sign-In • LinkedIn OAuth 2.0 • Dartz • PDF Generation',
        'bullets': [
          'Powered real-time peer-to-peer negotiation messaging via Socket.IO with reactive GetX UI updates and zero message loss.',
          'Implemented multi-provider authentication (Email/Password, Google Sign-In, LinkedIn OAuth 2.0) with encrypted JWT sessions and automated bilingual (English/Hindi) PDF invoice generation.',
        ],
      },
      {
        'title': 'Secure Your Land & Agent Apps – Real Estate Platform',
        'company': 'HashStack Solutions',
        'tech': 'Flutter • Dart • GetX • Socket.IO • Google Maps SDK • Razorpay • Cashfree • Dartz • PDF Generation',
        'bullets': [
          'Built a Socket.IO real-time chat module with read/unread status and automatic reconnection, plus a dynamic service quoting engine that auto-generates and emails PDF service contracts.',
          'Integrated Razorpay and Cashfree for secure in-app service payments with confirmation callbacks and transaction history tracking.',
        ],
      },
      {
        'title': 'Dhanusya Rider – Wallet & Supply Chain App',
        'company': 'HashStack Solutions',
        'tech': 'Flutter • Dart • GetX • Clean Architecture • Dio • Dartz • Firebase FCM • JWT • OTP Authentication',
        'bullets': [
          'Architected a Domain-Driven Design Flutter app supporting 5 distinct user roles with role-based UI rendering and OTP-based JWT authentication.',
          'Built a digital wallet for real-time financial tracking and automated payouts based on daily collection metrics, with a paginated multi-filter reporting module.',
        ],
      },
      {
        'title': 'CMA – Video Streaming Platform',
        'company': 'HashStack Solutions',
        'tech': 'Flutter • Dart • GetX • Dio • Dartz • Better Player • YouTube Player Flutter • Firebase • Video Compress',
        'bullets': [
          'Developed a hybrid video playback engine integrating native MP4/HLS streams and embedded YouTube content within a unified UI context.',
          'Engineered an on-device video compression pipeline, reducing server bandwidth consumption by 60%, with visibility-based playback control to prevent memory leaks and battery drain.',
        ],
      },
    ];

    for (final p in projects) {
      checkPageBreak(60);
      // Title + company right-aligned
      final cmpText = p['company'] as String;
      final cmpW    = fSmBold.measureString(cmpText).width;
      page.graphics.drawString(
        p['title'] as String, fBold,
        brush: PdfSolidBrush(darkGrey),
        bounds: Rect.fromLTWH(0, y, w - cmpW - 4, 14),
      );
      page.graphics.drawString(
        cmpText, fSmBold,
        brush: PdfSolidBrush(primary),
        bounds: Rect.fromLTWH(w - cmpW, y, cmpW, 14),
      );
      y += 15;
      // Tech stack
      textBlock(p['tech'] as String, fSm, color: midGrey, bottomPad: 4);
      // Bullets
      for (final b in (p['bullets'] as List<String>)) {
        textBlock('• $b', fReg, indent: 10, bottomPad: 3);
      }
      y += 8;
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // EDUCATION
    // ═══════════════════════════════════════════════════════════════════════════
    sectionHeading('Education');
    for (final edu in ResumeData.education) {
      checkPageBreak(36);
      final yearText = edu['year'] as String;
      final yearW    = fSmBold.measureString(yearText).width;
      page.graphics.drawString(
        edu['degree'] as String, fBold,
        brush: PdfSolidBrush(darkGrey),
        bounds: Rect.fromLTWH(0, y, w - yearW - 4, 14),
      );
      page.graphics.drawString(
        yearText, fSmBold,
        brush: PdfSolidBrush(primary),
        bounds: Rect.fromLTWH(w - yearW, y, yearW, 14),
      );
      y += 15;
      textBlock(edu['college'] as String, fReg, color: midGrey, indent: 10, bottomPad: 6);
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // ACHIEVEMENTS
    // ═══════════════════════════════════════════════════════════════════════════
    sectionHeading('Achievements');
    for (final a in ResumeData.achievements) {
      textBlock('• $a', fReg, indent: 10, bottomPad: 4);
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // DECLARATION
    // ═══════════════════════════════════════════════════════════════════════════
    sectionHeading('Declaration');
    textBlock(ResumeData.declaration, fReg, bottomPad: 10);
    y += 6;
    textBlock(ResumeData.name, fBold, bottomPad: 2);
    textBlock('Flutter Developer', fSm, color: midGrey, bottomPad: 2);

    final bytes = Uint8List.fromList(await doc.save());
    doc.dispose();
    return bytes;
  }

  // ─── Web download via anchor click ───────────────────────────────────────────
  static Future<void> _downloadWeb(Uint8List bytes) async {
    final blob = html.Blob([bytes], 'application/pdf');
    final url  = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'Anil_Kumar_Malipeddi_Resume.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // ─── Mobile: save to temp dir and open ───────────────────────────────────────
  static Future<void> _openMobile(Uint8List bytes) async {
    try {
      final dir  = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/Anil_Kumar_Malipeddi_Resume.pdf');
      await file.writeAsBytes(bytes, flush: true);
      await OpenFile.open(file.path);
    } catch (_) {
      // no-op
    }
  }
}
