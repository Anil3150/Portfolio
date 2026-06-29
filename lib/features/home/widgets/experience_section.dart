import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../data/resume_data.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final experience = ResumeData.experience;

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Professional Experience",
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ).animate(target: _isVisible ? 1 : 0).fade().slideY(begin: 0.5, end: 0),
            const SizedBox(height: 16),
            Container(
              width: 60, height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate(target: _isVisible ? 1 : 0).scaleX(),
            const SizedBox(height: 60),
            ...experience.asMap().entries.map((entry) {
              return _buildExperienceCard(
                context, entry.value, isMobile, entry.key,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(
    BuildContext context,
    Map<String, dynamic> exp,
    bool isMobile,
    int index,
  ) {
    final cardContent = GlassContainer(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company & Duration row
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exp['company'],
                    style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                  ),
                  Text(
                    exp['duration'],
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(exp['role'], style: AppTextStyles.h3),
          const Divider(height: 32),
          // Responsibilities
          ...List<Widget>.from(
            (exp['responsibilities'] as List).map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7, right: 10),
                      child: Icon(Icons.arrow_right_rounded, size: 20, color: AppColors.accent),
                    ),
                    Expanded(
                      child: Text(item as String, style: AppTextStyles.body),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Tech chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List<Widget>.from(
              (exp['technologies'] as List).map(
                (tech) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Text(
                    tech as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: cardContent
            .animate(target: _isVisible ? 1 : 0)
            .fade(delay: (200 * index).ms)
            .slideY(begin: 0.1, end: 0),
      );
    }

    // Desktop: show dot + line on left
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot + line
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                Container(width: 2, height: 80, color: AppColors.primary.withOpacity(0.25)),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: cardContent
                .animate(target: _isVisible ? 1 : 0)
                .fade(delay: (200 * index).ms)
                .slideX(begin: 0.05, end: 0),
          ),
        ],
      ),
    );
  }
}
