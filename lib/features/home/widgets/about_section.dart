import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/responsive_widgets.dart';
import '../../../data/resume_data.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_visible) {
          setState(() => _visible = true);
        }
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
                title: "About Me",
                subtitle: "Passionate about building great mobile experiences",
              ).animate(target: _visible ? 1 : 0).fade().slideY(begin: 0.3, end: 0),
              const SizedBox(height: 48),
              GlassContainer(
                padding: EdgeInsets.all(AppSpacing.cardPad(w)),
                child: Column(
                  children: [
                    // Summary text
                    Text(
                      ResumeData.summary,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.85),
                      ),
                      textAlign: TextAlign.justify,
                    ).animate(target: _visible ? 1 : 0).fade(delay: 200.ms),
                    const SizedBox(height: 40),
                    // Info row
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _InfoChip(Icons.location_on_rounded, ResumeData.location),
                        _InfoChip(Icons.email_rounded, ResumeData.email),
                        _InfoChip(Icons.work_rounded, "HashStack Solutions"),
                      ],
                    ).animate(target: _visible ? 1 : 0).fade(delay: 300.ms),
                    const SizedBox(height: 40),
                    // Stats
                    LayoutBuilder(builder: (ctx, cons) {
                      final cols = cons.maxWidth > 500 ? 4 : 2;
                      final itemW = (cons.maxWidth - 16 * (cols - 1)) / cols;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: ResumeData.stats
                            .map((s) => SizedBox(
                                  width: itemW,
                                  child: _StatCard(value: s['value']!, label: s['label']!),
                                ))
                            .toList(),
                      );
                    }).animate(target: _visible ? 1 : 0).fade(delay: 400.ms).slideY(begin: 0.15, end: 0),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.06), AppColors.secondary.withValues(alpha: 0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primary, fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
