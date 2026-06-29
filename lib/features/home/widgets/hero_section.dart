import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/url_launcher_util.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/responsive_widgets.dart';
import '../../../core/services/resume_service.dart';
import '../../../data/resume_data.dart';
import '../home_controller.dart';

class HeroSection extends StatelessWidget {
  final HomeController ctrl;
  const HeroSection({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final layout = w.layoutType;

        return Container(
          constraints: BoxConstraints(
            minHeight: layout == LayoutType.mobile ? 500 : 600,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.04),
                AppColors.secondary.withValues(alpha: 0.03),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ResponsiveContainer(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sectionH(w),
              vertical: AppSpacing.sectionV(w),
            ),
            child:
                layout == LayoutType.mobile
                    ? _MobileHero(ctrl: ctrl)
                    : _WideHero(
                      ctrl: ctrl,
                      compact: layout == LayoutType.tablet,
                    ),
          ),
        );
      },
    );
  }
}

// ── Mobile single-column layout ───────────────────────────────────────────────
class _MobileHero extends StatelessWidget {
  final HomeController ctrl;
  const _MobileHero({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileAvatar(size: 180),
        const SizedBox(height: 28),
        _HeroText(isMobile: true),
        const SizedBox(height: 28),
        _ActionButtons(ctrl: ctrl, isMobile: true),
      ],
    );
  }
}

// ── Tablet / Desktop two-column layout ───────────────────────────────────────
class _WideHero extends StatelessWidget {
  final HomeController ctrl;
  final bool compact;
  const _WideHero({required this.ctrl, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeroText(isMobile: false),
              SizedBox(height: compact ? 24 : 36),
              _ActionButtons(ctrl: ctrl, isMobile: false),
            ],
          ),
        ),
        SizedBox(width: compact ? 32 : 56),
        _ProfileAvatar(size: compact ? 240 : 300),
      ],
    );
  }
}

// ── Text block ────────────────────────────────────────────────────────────────
class _HeroText extends StatelessWidget {
  final bool isMobile;
  const _HeroText({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final align = isMobile ? TextAlign.center : TextAlign.left;
    final cross =
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          "Hi, I'm",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: align,
        ).animate().fade(duration: 500.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 6),
        Text(
              ResumeData.name,
              textAlign: align,
              style: (isMobile
                      ? textTheme.headlineMedium
                      : textTheme.displaySmall)
                  ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1),
            )
            .animate()
            .fade(duration: 500.ms, delay: 150.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: DefaultTextStyle(
            style: (textTheme.titleLarge ?? const TextStyle()).copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                TypewriterAnimatedText('Flutter Developer', speed: 90.ms),
                TypewriterAnimatedText('Mobile App Developer', speed: 90.ms),
                TypewriterAnimatedText('Cross Platform Engineer', speed: 90.ms),
              ],
            ),
          ),
        ).animate().fade(duration: 500.ms, delay: 300.ms),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
                "Building scalable cross-platform apps with clean architecture and pixel-perfect UI.",
                textAlign: align,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.7,
                ),
              )
              .animate()
              .fade(duration: 500.ms, delay: 450.ms)
              .slideY(begin: 0.2, end: 0),
        ),
      ],
    );
  }
}

// ── CTA Buttons ───────────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final HomeController ctrl;
  final bool isMobile;
  const _ActionButtons({required this.ctrl, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Wrap(
              alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: ResumeService.download,
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text("Download Resume"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: ctrl.scrollToProjects,
                  icon: const Icon(Icons.folder_open_rounded, size: 18),
                  label: const Text("View Projects"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: ctrl.scrollToContact,
                  icon: const Icon(Icons.mail_outline_rounded, size: 18),
                  label: const Text("Contact Me"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            )
            .animate()
            .fade(duration: 500.ms, delay: 600.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            _SocialIcon(
              icon: FontAwesomeIcons.github,
              url: "https://github.com/Anil3150",
              tooltip: "GitHub",
            ),
            _SocialIcon(
              icon: FontAwesomeIcons.linkedin,
              url: ResumeData.linkedIn,
              tooltip: "LinkedIn",
            ),
            _SocialIcon(
              icon: FontAwesomeIcons.envelope,
              url: "mailto:${ResumeData.email}",
              tooltip: "Email",
            ),
            _SocialIcon(
              icon: FontAwesomeIcons.phone,
              url: "tel:${ResumeData.phone}",
              tooltip: "Phone",
            ),
          ],
        ).animate().fade(duration: 500.ms, delay: 750.ms),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final String tooltip;
  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.tooltip,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color:
              _hovered
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: FaIcon(widget.icon, size: 18),
          color: _hovered ? AppColors.primary : Colors.grey.shade600,
          tooltip: widget.tooltip,
          onPressed: () => openUrl(widget.url),
        ),
      ),
    );
  }
}

// ── Profile Avatar ─────────────────────────────────────────────────────────────
class _ProfileAvatar extends StatelessWidget {
  final double size;
  const _ProfileAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: CircleAvatar(
          radius: 60, // Adjust as needed
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image.asset(
              'assets/images/anil_imagee.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover, // Fills the circle
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack);
  }
}
