import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/skill_items.dart';

class SkillsDesktop extends StatelessWidget {
  const SkillsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 450),
          child: Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: [
              for (int i = 0; i < platformItems.length; i++)
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colorss.bgLight2,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    leading: SizedBox(
                      width: 30, // fixed width
                      height: 30, // fixed height
                      child: Image.asset(
                        platformItems[i]["img"],
                        fit: BoxFit.cover,
                        color: Colorss.whiteSecondary,
                      ),
                    ),
                    title: Text(platformItems[i]["title"]),
                    titleTextStyle: TextStyle(
                      color: Colorss.whiteSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 50),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                for (int i = 0; i < skillItems.length; i++)
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: Colorss.bgLight2,
                    label: Text(skillItems[i]['title']),
                    labelStyle: TextStyle(
                      color: Colorss.whiteSecondary,
                      fontSize: 16,
                    ),
                    avatar: Image.asset(
                      skillItems[i]['img'],
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
