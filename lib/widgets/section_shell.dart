import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/core/app_constants.dart';

class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.sectionKey,
  });

  final GlobalKey? sectionKey;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 68),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(.68),
                ),
              ),
              const SizedBox(height: 28),
              child,
            ],
          ).animate().fadeIn(duration: 500.ms).slideY(begin: .08),
        ),
      ),
    );
  }
}
