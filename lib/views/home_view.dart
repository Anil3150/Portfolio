import 'package:flutter/material.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/nav_items.dart';
import 'package:portfolio/widgets/header_desktop.dart';
import 'package:portfolio/widgets/header_mobile.dart';
import 'package:portfolio/widgets/mobile_drawer.dart';

import '../constants/sizes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return LayoutBuilder(
      builder: (context, constraints) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colorss.scaffoldBg,
        endDrawer: constraints.maxWidth>=kMinDesktopWidth ? null: MobileDrawer(),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            constraints.maxWidth>=kMinDesktopWidth?
            HeaderDesktop():
            HeaderMobile(onLogoTap: () {}, onMenuTap: () {
              scaffoldKey.currentState?.openEndDrawer();
            }),
            Container(
              height: 300,
              width: double.maxFinite,
              color: Colors.blueGrey,
            ),
            Container(
              height: 300,
              width: double.maxFinite,
              color: Colors.blueGrey,
            ),
            Container(
              height: 300,
              width: double.maxFinite,
              color: Colors.blueGrey,
            ),
            Container(
              height: 300,
              width: double.maxFinite,
              color: Colors.blueGrey,
            ),
          ],
        ),
      );
      },
    );
  }
}
