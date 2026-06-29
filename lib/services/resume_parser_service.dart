import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:portfolio/core/app_constants.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ResumeParserService {
  Future<PortfolioData> parseBytes({
    required Uint8List bytes,
    required String fileName,
    required PortfolioData fallback,
  }) async {
    final lowerName = fileName.toLowerCase();
    final text =
        lowerName.endsWith('.pdf')
            ? _extractPdfText(bytes)
            : lowerName.endsWith('.docx')
            ? _extractDocxText(bytes)
            : utf8.decode(bytes, allowMalformed: true);

    return parseText(text, fallback: fallback, fileName: fileName);
  }

  PortfolioData parseText(
    String text, {
    required PortfolioData fallback,
    String fileName = 'uploaded_resume',
  }) {
    final normalized = _normalize(text);
    final lines =
        normalized
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();

    final email =
        _firstMatch(normalized, RegExp(r'[\w\.\-]+@[\w\.\-]+\.\w+')) ??
        fallback.profile.email;
    final phone =
        _firstMatch(normalized, RegExp(r'(\+?\d[\d\s-]{8,}\d)')) ??
        fallback.profile.phone;
    final linkedIn =
        _firstMatch(
          normalized,
          RegExp(r'https?:\/\/(www\.)?linkedin\.com\/[^\s]+'),
        ) ??
        fallback.profile.linkedIn;

    final name =
        lines.isNotEmpty ? _titleCase(lines.first) : fallback.profile.name;
    final designation = _findDesignation(lines) ?? fallback.profile.designation;
    final summary =
        _sectionText(
          normalized,
          ['Profile Summary', 'Summary'],
          ['Skills', 'Work Experience', 'Experience'],
        ) ??
        fallback.profile.summary;

    return PortfolioData(
      profile: fallback.profile.copyWith(
        name: name,
        designation: designation.replaceAll('Sofware', 'Software'),
        summary: summary,
        email: email.replaceFirst('mailto:', ''),
        phone: phone.replaceAll(RegExp(r'\s+'), ' ').trim(),
        linkedIn: linkedIn,
        resumeFileName: fileName,
        profileImage: AppConstants.profileImagePath,
        roles: _rolesFromText(normalized, fallback.profile.roles),
        yearsOfExperience:
            _yearsFromText(normalized) ?? fallback.profile.yearsOfExperience,
      ),
      highlights: _bulletsForSection(
        normalized,
        ['Profile Summary'],
        ['Skills', 'Work Experience'],
      ).take(5).toList().ifEmpty(fallback.highlights),
      skillCategories: _skillsFromText(normalized, fallback.skillCategories),
      experiences: _experienceFromText(normalized, fallback.experiences),
      projects: _projectsFromText(normalized, fallback.projects),
      education: _educationFromText(normalized, fallback.education),
      certifications: _certificationsFromText(
        normalized,
        fallback.certifications,
      ),
      services: fallback.services,
      testimonials: fallback.testimonials,
    );
  }

  String _extractPdfText(Uint8List bytes) {
    final document = PdfDocument(inputBytes: bytes);
    final text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }

  String _extractDocxText(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final document = archive.files.firstWhere(
      (file) => file.name == 'word/document.xml',
      orElse: () => throw FormatException('Invalid DOCX file'),
    );
    final xml = utf8.decode(
      document.content as List<int>,
      allowMalformed: true,
    );
    return RegExp(r'<w:t[^>]*>(.*?)<\/w:t>', dotAll: true)
        .allMatches(xml)
        .map((match) => _decodeXml(match.group(1) ?? ''))
        .join(' ');
  }

  List<SkillCategory> _skillsFromText(
    String text,
    List<SkillCategory> fallback,
  ) {
    final known = <String>[
      'Flutter',
      'Dart',
      'GetX',
      'BLoC',
      'Java',
      'SQL',
      'Dio',
      'REST APIs',
      'Firebase',
      'Socket.IO',
      'Google Sign-In',
      'Git',
      'GitHub',
      'Clean Architecture',
      'SOLID',
      'MVVM',
      'LayoutBuilder',
      'Razorpay',
      'Cashfree',
      'Google Maps',
    ];
    final found =
        known
            .where((skill) => text.toLowerCase().contains(skill.toLowerCase()))
            .toSet()
            .toList();
    if (found.isEmpty) return fallback;

    return [
      SkillCategory(
        title: 'Extracted Technology Stack',
        skills: found,
        strength: .88,
      ),
      ...fallback.where((item) => item.title != 'Extracted Technology Stack'),
    ];
  }

  List<ExperienceItem> _experienceFromText(
    String text,
    List<ExperienceItem> fallback,
  ) {
    final workText = _sectionText(
      text,
      ['WORK EXPERIENCE', 'Work Experience', 'Experience'],
      ['PROJECTS', 'Projects', 'CERTIFICATIONS'],
    );
    if (workText == null || !workText.toLowerCase().contains('hashstack')) {
      return fallback;
    }
    return [
      ExperienceItem(
        company: 'HashStack Solutions',
        role: 'Software Engineer (Flutter)',
        duration:
            _firstMatch(
              workText,
              RegExp(r'(Apr\s+2024\s+-\s+Present)', caseSensitive: false),
            ) ??
            fallback.first.duration,
        location:
            workText.toLowerCase().contains('visakhapatnam')
                ? 'Visakhapatnam'
                : fallback.first.location,
        achievements: _sentences(workText).take(6).toList(),
      ),
    ];
  }

  List<ProjectItem> _projectsFromText(String text, List<ProjectItem> fallback) {
    final titles = [
      'Dhenusya Rider',
      'CMA',
      'Bizztiny',
      'Secure Your Land',
      'Agri Insights',
    ];
    final extracted = <ProjectItem>[];
    for (var i = 0; i < titles.length; i++) {
      final nextTitles =
          titles.skip(i + 1).toList()..addAll(['CERTIFICATIONS', 'EDUCATION']);
      final section = _sectionText(text, [titles[i]], nextTitles);
      if (section == null) continue;
      extracted.add(
        ProjectItem(
          title: titles[i],
          description:
              _sentences(section).firstOrNull ??
              fallback
                  .firstWhere(
                    (item) => item.title == titles[i],
                    orElse: () => fallback.first,
                  )
                  .description,
          technologies: _technologyTags(section),
          highlights: _sentences(section).skip(1).take(4).toList(),
        ),
      );
    }
    return extracted.isEmpty ? fallback : extracted;
  }

  List<EducationItem> _educationFromText(
    String text,
    List<EducationItem> fallback,
  ) {
    final education = _sectionText(
      text,
      ['EDUCATION', 'Education'],
      ['DECLARATION'],
    );
    if (education == null) return fallback;
    return [
      EducationItem(
        degree:
            education.contains('Bachelor of Technology')
                ? 'Bachelor of Technology (B.Tech), Electronics and Communication Engineering'
                : fallback.first.degree,
        institution:
            education.contains('Peter')
                ? "St. Peter's Engineering College, Hyderabad"
                : fallback.first.institution,
        duration:
            _firstMatch(
              education,
              RegExp(r'July\s+2018\s+-\s+August\s+2022', caseSensitive: false),
            ) ??
            fallback.first.duration,
      ),
    ];
  }

  List<CertificationItem> _certificationsFromText(
    String text,
    List<CertificationItem> fallback,
  ) {
    final section = _sectionText(
      text,
      ['CERTIFICATIONS', 'Certifications'],
      ['EDUCATION'],
    );
    if (section == null) return fallback;
    final items = <CertificationItem>[];
    if (section.toLowerCase().contains('java')) {
      items.add(
        const CertificationItem(
          title: 'Java Programming',
          issuer: 'Naresh Technologies',
        ),
      );
    }
    if (section.toLowerCase().contains('oracle')) {
      items.add(
        const CertificationItem(
          title: 'Oracle Database',
          issuer: 'Naresh Technologies',
        ),
      );
    }
    return items.isEmpty ? fallback : items;
  }

  List<String> _rolesFromText(String text, List<String> fallback) {
    final roles = <String>{
      if (text.toLowerCase().contains('flutter')) 'Flutter Developer',
      if (text.toLowerCase().contains('getx')) 'GetX Specialist',
      if (text.toLowerCase().contains('clean architecture'))
        'Clean Architecture Practitioner',
      if (text.toLowerCase().contains('software engineer')) 'Software Engineer',
    };
    return roles.isEmpty ? fallback : roles.toList();
  }

  List<String> _technologyTags(String text) {
    const tags = [
      'Flutter',
      'Dart',
      'GetX',
      'Dio',
      'REST APIs',
      'Firebase',
      'Socket.IO',
      'Google Maps',
      'Razorpay',
      'Cashfree',
      'JWT',
      'FCM',
    ];
    return tags
        .where((tag) => text.toLowerCase().contains(tag.toLowerCase()))
        .toList();
  }

  List<String> _bulletsForSection(
    String text,
    List<String> starts,
    List<String> ends,
  ) {
    final section = _sectionText(text, starts, ends);
    if (section == null) return const [];
    return _sentences(section);
  }

  List<String> _sentences(String text) =>
      text
          .replaceAll(' - ', ' ')
          .split(RegExp(r'(?<=[.])\s+|[●•]\s*'))
          .map((line) => line.trim())
          .where((line) => line.length > 24)
          .toList();

  String? _sectionText(String text, List<String> starts, List<String> ends) {
    final lower = text.toLowerCase();
    var startIndex = -1;
    for (final start in starts) {
      startIndex = lower.indexOf(start.toLowerCase());
      if (startIndex >= 0) {
        startIndex += start.length;
        break;
      }
    }
    if (startIndex < 0) return null;

    var endIndex = text.length;
    for (final end in ends) {
      final candidate = lower.indexOf(end.toLowerCase(), startIndex);
      if (candidate >= 0 && candidate < endIndex) endIndex = candidate;
    }
    return text.substring(startIndex, endIndex).trim();
  }

  String? _findDesignation(List<String> lines) {
    return lines.firstWhereOrNull(
      (line) =>
          line.toLowerCase().contains('developer') ||
          line.toLowerCase().contains('engineer'),
    );
  }

  double? _yearsFromText(String text) {
    final match = RegExp(
      r'(\d+(?:\.\d+)?)\s+years?',
      caseSensitive: false,
    ).firstMatch(text);
    return match == null ? null : double.tryParse(match.group(1)!);
  }

  String? _firstMatch(String text, RegExp regExp) =>
      regExp.firstMatch(text)?.group(0);

  String _normalize(String text) =>
      text
          .replaceAll('\u00a0', ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .replaceAll(' | ', '\n')
          .replaceAll(' Profile Summary', '\nProfile Summary')
          .replaceAll(' Skills ', '\nSkills\n')
          .replaceAll(' WORK EXPERIENCE ', '\nWORK EXPERIENCE\n')
          .replaceAll(' PROJECTS ', '\nPROJECTS\n')
          .replaceAll(' CERTIFICATIONS ', '\nCERTIFICATIONS\n')
          .replaceAll(' EDUCATION ', '\nEDUCATION\n')
          .trim();

  String _decodeXml(String value) => value
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'");

  String _titleCase(String value) => value
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}

extension _ListHelpers<T> on List<T> {
  List<T> ifEmpty(List<T> fallback) => isEmpty ? fallback : this;

  T? get firstOrNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T item) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
