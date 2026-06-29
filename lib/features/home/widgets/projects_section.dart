import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/responsive_widgets.dart';
import '../../../data/resume_data.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});
  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('projects-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.05 && !_visible) setState(() => _visible = true);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        return ResponsiveContainer(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sectionH(w),
            vertical: AppSpacing.sectionV(w),
          ),
          child: Column(
            children: [
              const SectionHeader(
                title: "Featured Projects",
                subtitle: "Production apps shipped across 5+ business domains",
              ).animate(target: _visible ? 1 : 0).fade().slideY(begin: 0.3, end: 0),
              const SizedBox(height: 56),
              ResponsiveGrid(
                itemMinWidth: 340,
                spacing: AppSpacing.gridGap(w),
                runSpacing: AppSpacing.gridGap(w),
                itemHeight: 470,
                children: ResumeData.projects.asMap().entries.map((e) {
                  return _ProjectCard(project: e.value, index: e.key, visible: _visible);
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final int index;
  final bool visible;
  const _ProjectCard({required this.project, required this.index, required this.visible});
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: GlassContainer(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thumbnail
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.secondary.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(Icons.phone_iphone_rounded, size: 56, color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    Positioned(
                      top: 12, right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(p['category'] as String,
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['title'] as String,
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(p['description'] as String,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600, height: 1.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tech tags
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: (p['technologies'] as List).take(4).map((t) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text("#$t",
                                style: textTheme.labelSmall?.copyWith(
                                  color: AppColors.secondary, fontWeight: FontWeight.w600)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.open_in_new_rounded, size: 15),
                          label: const Text("Play Store"),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.github, size: 18),
                          color: AppColors.primary,
                          onPressed: () {},
                          tooltip: "GitHub",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    ).animate(target: widget.visible ? 1 : 0)
     .fade(delay: (80 * widget.index).ms)
     .slideY(begin: 0.15, end: 0);
  }
}
