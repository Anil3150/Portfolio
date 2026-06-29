import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/responsive_widgets.dart';
import '../../../data/resume_data.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});
  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) setState(() => _visible = true);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        // card min-width drives column count: 300 → 1col mobile, 2col tablet, 3col desktop
        return ResponsiveContainer(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sectionH(w),
            vertical: AppSpacing.sectionV(w),
          ),
          child: Column(
            children: [
              const SectionHeader(
                title: "Technical Skills",
                subtitle: "Technologies and tools I work with daily",
              ).animate(target: _visible ? 1 : 0).fade().slideY(begin: 0.3, end: 0),
              const SizedBox(height: 56),
              ResponsiveGrid(
                itemMinWidth: 300,
                spacing: AppSpacing.gridGap(w),
                runSpacing: AppSpacing.gridGap(w),
                children: ResumeData.skills.entries.map((e) {
                  return _SkillCard(
                    category: e.key,
                    skills: e.value,
                    isVisible: _visible,
                  );
                }).toList(),
              ).animate(target: _visible ? 1 : 0).fade(delay: 200.ms),
            ],
          ),
        );
      }),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> skills;
  final bool isVisible;
  const _SkillCard({required this.category, required this.skills, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.code_rounded, size: 18, color: AppColors.secondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(category,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.secondary, fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...skills.map((skill) => _SkillBar(skill: skill, isVisible: isVisible)),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final Map<String, dynamic> skill;
  final bool isVisible;
  const _SkillBar({required this.skill, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final pct = (skill['progress'] as double? ?? 0.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill['name'] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              Text("${(pct * 100).toInt()}%",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (ctx, cons) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(children: [
                Container(
                  height: 6, width: cons.maxWidth,
                  color: Colors.grey.withValues(alpha: 0.15),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1100),
                  curve: Curves.easeOutCubic,
                  height: 6,
                  width: isVisible ? cons.maxWidth * pct : 0,
                  decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                ),
              ]),
            );
          }),
        ],
      ),
    );
  }
}
