import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/responsive_widgets.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});
  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  bool _visible = false;

  static const _allServices = [
    {'title': 'Flutter App Development',    'icon': Icons.phone_iphone_rounded,     'desc': 'High-performance cross-platform apps for Android & iOS from a single codebase.'},
    {'title': 'REST API Integration',        'icon': Icons.cloud_sync_rounded,       'desc': 'Connecting mobile apps with RESTful APIs, WebSockets, and backend services using Dio.'},
    {'title': 'UI/UX Implementation',        'icon': Icons.design_services_rounded,  'desc': 'Translating Figma designs into pixel-perfect, animated Flutter interfaces.'},
    {'title': 'Payment Integration',         'icon': Icons.payments_rounded,         'desc': 'Razorpay, Cashfree, Stripe — secure payment flows with webhook handling.'},
    {'title': 'Firebase Integration',        'icon': Icons.local_fire_department_rounded, 'desc': 'Auth, FCM push notifications, Cloud Messaging, Firebase Core setup.'},
    {'title': 'App Deployment',              'icon': Icons.rocket_launch_rounded,    'desc': 'End-to-end deployment to Google Play Store & Apple App Store including TestFlight.'},
    {'title': 'Performance Optimization',   'icon': Icons.speed_rounded,            'desc': '60 FPS on low-end devices via image caching, lazy loading, and video compression.'},
    {'title': 'Bug Fixing & Code Review',   'icon': Icons.bug_report_rounded,       'desc': 'Diagnosing production crashes, standardizing error handling with Dartz.'},
  ];

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('services-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) setState(() => _visible = true);
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
                title: "Services",
                subtitle: "What I can build for you",
              ).animate(target: _visible ? 1 : 0).fade().slideY(begin: 0.3, end: 0),
              const SizedBox(height: 56),
              ResponsiveGrid(
                itemMinWidth: 260,
                spacing: AppSpacing.gridGap(w),
                runSpacing: AppSpacing.gridGap(w),
                itemHeight: 280,
                children: _allServices.asMap().entries.map((e) {
                  return _ServiceCard(service: e.value, index: e.key, visible: _visible);
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final Map<String, Object> service;
  final int index;
  final bool visible;
  const _ServiceCard({required this.service, required this.index, required this.visible});
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final icon = s['icon'] as IconData;
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _hovered
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 26,
                  color: _hovered ? Colors.white : AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(s['title'] as String,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Expanded(
                child: Text(s['desc'] as String,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600, height: 1.6),
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
