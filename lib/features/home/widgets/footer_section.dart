import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/url_launcher_util.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/resume_data.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(top: BorderSide(color: AppColors.primary.withValues(alpha: 0.15))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Social Icons
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _socialBtn(FontAwesomeIcons.github,   "https://github.com/"),
              _socialBtn(FontAwesomeIcons.linkedin,  ResumeData.linkedIn),
              _socialBtn(FontAwesomeIcons.envelope,  "mailto:${ResumeData.email}"),
              _socialBtn(FontAwesomeIcons.phone,     "tel:${ResumeData.phone}"),
            ],
          ),
          const SizedBox(height: 20),
          // Built with Flutter line
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              Text("Built with Flutter", style: AppTextStyles.body),
              const Icon(Icons.favorite_rounded, color: Colors.red, size: 16),
              Text("by Anil Kumar", style: AppTextStyles.body),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "© ${DateTime.now().year} Anil Kumar Malipeddi. All Rights Reserved.",
            style: AppTextStyles.caption.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(IconData icon, String url) {
    return IconButton(
      icon: FaIcon(icon, size: 20),
      color: AppColors.primary,
      onPressed: () => openUrl(url),
    );
  }
}
