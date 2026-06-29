import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/responsive_widgets.dart';
import '../../../data/resume_data.dart';

class EducationSection extends StatefulWidget {
  const EducationSection({super.key});
  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('education-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) setState(() => _visible = true);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isDesktop = w.isDesktop;

        return ResponsiveContainer(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sectionH(w),
            vertical: AppSpacing.sectionV(w),
          ),
          child: Column(
            children: [
              const SectionHeader(
                title: "Education & Achievements",
                subtitle: "Academic background and key professional wins",
              ).animate(target: _visible ? 1 : 0).fade().slideY(begin: 0.3, end: 0),
              const SizedBox(height: 56),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _educationBlock().animate(target: _visible ? 1 : 0)
                            .fade(delay: 200.ms).slideX(begin: -0.1, end: 0)),
                        SizedBox(width: AppSpacing.gridGap(w)),
                        Expanded(flex: 2, child: _achievementsBlock().animate(target: _visible ? 1 : 0)
                            .fade(delay: 350.ms).slideX(begin: 0.1, end: 0)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _educationBlock().animate(target: _visible ? 1 : 0)
                            .fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
                        SizedBox(height: AppSpacing.gridGap(w)),
                        _achievementsBlock().animate(target: _visible ? 1 : 0)
                            .fade(delay: 350.ms).slideY(begin: 0.1, end: 0),
                      ],
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget _educationBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BlockTitle(icon: Icons.school_rounded, title: "Education"),
        const SizedBox(height: 20),
        ...ResumeData.education.map((edu) => _EducationCard(edu: edu)),
      ],
    );
  }

  Widget _achievementsBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _BlockTitle(icon: Icons.emoji_events_rounded, title: "Key Achievements"),
        const SizedBox(height: 20),
        GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: ResumeData.achievements.asMap().entries.map((e) {
              return _AchievementTile(text: e.value, index: e.key);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _BlockTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _BlockTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _EducationCard extends StatelessWidget {
  final Map<String, dynamic> edu;
  const _EducationCard({required this.edu});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(edu['degree'] as String,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(edu['college'] as String,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(edu['year'] as String,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final String text;
  final int index;
  const _AchievementTile({required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = [AppColors.primary, AppColors.secondary, AppColors.accent, AppColors.primary];
    return Padding(
      padding: EdgeInsets.only(bottom: index < 3 ? 20 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            margin: const EdgeInsets.only(right: 14, top: 2),
            decoration: BoxDecoration(
              color: colors[index % colors.length].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text("${index + 1}",
                style: TextStyle(
                  color: colors[index % colors.length],
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.65)),
          ),
        ],
      ),
    );
  }
}
