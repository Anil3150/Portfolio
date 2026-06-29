import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final scrollController = ScrollController();

  // GlobalKeys for each section
  final heroKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final experienceKey = GlobalKey();
  final projectsKey = GlobalKey();
  final servicesKey = GlobalKey();
  final educationKey = GlobalKey();
  final contactKey = GlobalKey();

  final RxInt activeNavIndex = 0.obs;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void scrollToSection(GlobalKey key, int navIndex) {
    activeNavIndex.value = navIndex;
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  void scrollToHero() => scrollToSection(heroKey, 0);
  void scrollToAbout() => scrollToSection(aboutKey, 1);
  void scrollToSkills() => scrollToSection(skillsKey, 2);
  void scrollToExperience() => scrollToSection(experienceKey, 3);
  void scrollToProjects() => scrollToSection(projectsKey, 4);
  void scrollToServices() => scrollToSection(servicesKey, 5);
  void scrollToEducation() => scrollToSection(educationKey, 6);
  void scrollToContact() => scrollToSection(contactKey, 7);
}
