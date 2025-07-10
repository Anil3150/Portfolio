import 'package:flutter/material.dart';
import 'package:portfolio/widgets/site_logo.dart';

import '../constants/colors.dart';
import '../constants/nav_items.dart';
import '../styles/style.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: kHeaderDecoration,
      child: Row(
        children: [
          SiteLogo(),
          Spacer(),
          for (int i = 0; i < navTitles.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  navTitles[i],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colorss.whitePrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
