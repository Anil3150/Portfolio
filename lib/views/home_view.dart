import 'package:flutter/material.dart';
import 'package:portfolio/widgets/about_desktop.dart';
import 'package:portfolio/widgets/about_mobile.dart';
import 'package:portfolio/widgets/contact_section.dart';
import 'package:portfolio/widgets/projects_section.dart';
import 'package:portfolio/widgets/skills_desktop.dart';
import 'package:portfolio/widgets/skills_mobile.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../widgets/header_desktop.dart';
import '../widgets/header_mobile.dart';
import '../widgets/main_desktop.dart';
import '../widgets/main_mobile.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/work_expierence_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= kMinDesktopWidth;

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colorss.scaffoldBg,
          endDrawer: isDesktop ? null : const MobileDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                // Constant header
                isDesktop
                    ? const HeaderDesktop()
                    : HeaderMobile(
                      onLogoTap: () {},
                      onMenuTap: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                // Scrollable content
                Expanded(
                  child: ListView(
                    children: [
                      isDesktop ? const MainDesktop() : const MainMobile(),
                      isDesktop ? const AboutDesktop() : const AboutMobile(),
                      Container(
                        padding: EdgeInsets.fromLTRB(25, 20, 25, 60),
                        width: screenWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'What I Can Do',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colorss.whitePrimary,
                              ),
                            ),
                            SizedBox(height: 50),
                            isDesktop ? SkillsDesktop() : SkillsMobile(),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(25, 20, 25, 60),
                        width: screenWidth,
                        color: Colorss.bgLight1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Work Experience',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colorss.whitePrimary,
                              ),
                            ),
                            SizedBox(height: 50),
                            WorkExperienceSection(
                              screenWidth: screenWidth,
                              isDesktop: isDesktop,
                            ),
                          ],
                        ),
                      ),
                      ProjectsSection(),
                      ContactSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
