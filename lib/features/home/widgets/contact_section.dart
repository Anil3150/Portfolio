import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/url_launcher_util.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/breakpoints.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/responsive_widgets.dart';
import '../../../data/resume_data.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});
  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _visible = false;
  BuildContext? _ctx;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('contact-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_visible) setState(() => _visible = true);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        _ctx = context;
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
                title: "Get In Touch",
                subtitle: "Open to new opportunities and collaborations",
              ).animate(target: _visible ? 1 : 0).fade().slideY(begin: 0.3, end: 0),
              const SizedBox(height: 56),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _contactInfo().animate(target: _visible ? 1 : 0)
                              .fade(delay: 200.ms).slideX(begin: -0.1, end: 0),
                        ),
                        SizedBox(width: AppSpacing.gridGap(w)),
                        Expanded(
                          flex: 3,
                          child: _contactForm(context).animate(target: _visible ? 1 : 0)
                              .fade(delay: 350.ms).slideX(begin: 0.1, end: 0),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _contactInfo().animate(target: _visible ? 1 : 0)
                            .fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
                        SizedBox(height: AppSpacing.gridGap(w)),
                        _contactForm(context).animate(target: _visible ? 1 : 0)
                            .fade(delay: 350.ms).slideY(begin: 0.1, end: 0),
                      ],
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget _contactInfo() {
    final ctx = _ctx!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Let's build something great together!",
          style: Theme.of(ctx).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          "I'm always open to discussing new projects, creative ideas, or opportunities to be part of your vision.",
          style: Theme.of(ctx).textTheme.bodyLarge
              ?.copyWith(color: Colors.grey.shade600, height: 1.7),
        ),
        const SizedBox(height: 32),
        _ContactInfoItem(Icons.email_rounded, "Email", ResumeData.email,
            () => _launch("mailto:${ResumeData.email}")),
        _ContactInfoItem(Icons.phone_rounded, "Phone", ResumeData.phone,
            () => _launch("tel:${ResumeData.phone}")),
        _ContactInfoItem(Icons.location_on_rounded, "Location", ResumeData.location, () {}),
        const SizedBox(height: 28),
        Wrap(
          spacing: 8,
          children: [
            _SocialChip(FontAwesomeIcons.linkedin, "LinkedIn",
                () => _launch(ResumeData.linkedIn)),
            _SocialChip(FontAwesomeIcons.github, "GitHub",
                () => _launch("https://github.com/Anil3150")),
            _SocialChip(FontAwesomeIcons.envelope, "Email",
                () => _launch("mailto:${ResumeData.email}")),
          ],
        ),
      ],
    );
  }

  Widget _contactForm(BuildContext ctx) {
    return GlassContainer(
      padding: const EdgeInsets.all(28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FormField(label: "Name",    hint: "Your full name",    ctrl: _nameCtrl),
            const SizedBox(height: 16),
            _FormField(label: "Email",   hint: "your@email.com",    ctrl: _emailCtrl,   isEmail: true),
            const SizedBox(height: 16),
            _FormField(label: "Message", hint: "Tell me about your project...", ctrl: _messageCtrl, maxLines: 5),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text("Send Message"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(_ctx!).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text("Message sent! I'll get back to you soon."),
          ]),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _nameCtrl.clear();
      _emailCtrl.clear();
      _messageCtrl.clear();
    }
  }

  void _launch(String url) => openUrl(url);
}

// ── Info item ─────────────────────────────────────────────────────────────────
class _ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _ContactInfoItem(this.icon, this.label, this.value, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(value,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Social chip ───────────────────────────────────────────────────────────────
class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialChip(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: FaIcon(icon, size: 14, color: AppColors.primary),
      label: Text(label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
      onPressed: onTap,
      backgroundColor: AppColors.primary.withValues(alpha: 0.07),
      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

// ── Form field ────────────────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController ctrl;
  final bool isEmail;
  final int maxLines;
  const _FormField({
    required this.label, required this.hint, required this.ctrl,
    this.isEmail = false, this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.multiline,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Please enter $label';
            if (isEmail && !v.contains('@')) return 'Enter a valid email';
            return null;
          },
        ),
      ],
    );
  }
}
