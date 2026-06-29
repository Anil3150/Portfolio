import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/services/resume_parser_service.dart';
import 'package:portfolio/core/app_constants.dart';
import 'package:portfolio/utils/download_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioController extends GetxController {
  PortfolioController(this._repository, this._resumeParserService);

  final PortfolioRepository _repository;
  final ResumeParserService _resumeParserService;

  final data = Rxn<PortfolioData>();
  final isLoading = true.obs;
  final isParsingResume = false.obs;
  final isDarkMode = true.obs;
  final selectedNavIndex = 0.obs;
  final generatedJson = ''.obs;

  final scrollController = ScrollController();
  final sectionKeys = List.generate(9, (_) => GlobalKey());
  final navItems = const [
    'Home',
    'About',
    'Skills',
    'Experience',
    'Projects',
    'Education',
    'Services',
    'Testimonials',
    'Contact',
  ];

  @override
  void onInit() {
    super.onInit();
    final seed = _repository.loadSeedPortfolio();
    data.value = seed;
    generatedJson.value = const JsonEncoder.withIndent(
      '  ',
    ).convert(seed.toJson());
    isLoading.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void scrollToSection(int index) {
    selectedNavIndex.value = index;
    final context = sectionKeys[index].currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: 800.milliseconds,
      curve: Curves.easeInOutCubic,
      alignment: .02,
    );
  }

  Future<void> pickAndParseResume() async {
    isParsingResume.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'docx', 'txt'],
        withData: true,
      );
      if (result == null || result.files.single.bytes == null) return;
      final current = data.value ?? _repository.loadSeedPortfolio();
      final parsed = await _resumeParserService.parseBytes(
        bytes: result.files.single.bytes!,
        fileName: result.files.single.name,
        fallback: current,
      );
      data.value = parsed;
      generatedJson.value = const JsonEncoder.withIndent(
        '  ',
      ).convert(parsed.toJson());
      Get.snackbar(
        'Resume parsed',
        'Portfolio sections were regenerated from ${result.files.single.name}.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Could not parse resume',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isParsingResume.value = false;
    }
  }

  Future<void> downloadCv() async {
    try {
      final fileName =
          data.value?.profile.resumeFileName ??
          AppConstants.resumeAssetPath.split('/').last;
      await downloadAsset(AppConstants.resumeAssetPath, fileName);
    } catch (error) {
      Get.snackbar(
        'Could not download CV',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void applyManualJson(String value) {
    try {
      final decoded = jsonDecode(value) as Map<String, dynamic>;
      final parsed = PortfolioData.fromJson(decoded);
      data.value = parsed;
      generatedJson.value = const JsonEncoder.withIndent(
        '  ',
      ).convert(parsed.toJson());
      Get.back();
      Get.snackbar('Portfolio updated', 'Manual JSON changes are now live.');
    } catch (error) {
      Get.snackbar('Invalid JSON', error.toString());
    }
  }

  Future<void> launchExternal(String value) async {
    if (value.trim().isEmpty) return;
    final uri = Uri.parse(value);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> launchEmail(String email) async {
    await launchExternal('mailto:$email');
  }

  Future<void> launchPhone(String phone) async {
    await launchExternal('tel:$phone');
  }

  Future<void> launchWhatsApp(String phone) async {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    await launchExternal('https://wa.me/$digits');
  }
}
