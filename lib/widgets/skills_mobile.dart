import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/skill_items.dart';

class SkillsMobile extends StatelessWidget {
  const SkillsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          for (int i = 0; i < platformItems.length; i++)
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colorss.bgLight2,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                leading: Image.asset(
                  platformItems[i]["img"],
                  width: 30,
                  height: 30,
                  color: Colorss.whiteSecondary,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  platformItems[i]["title"],
                  style: TextStyle(color: Colorss.whiteSecondary, fontSize: 16),
                ),
              ),
            ),
          SizedBox(height: 50),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            alignment: WrapAlignment.center,
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
        ],
      ),
    );
  }
}
