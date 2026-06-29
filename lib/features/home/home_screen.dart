import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/breakpoints.dart';
import 'home_controller.dart';
import 'widgets/hero_section.dart';
import 'widgets/about_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/education_section.dart';
import 'widgets/services_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/footer_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final showDrawer = w < AppBreakpoints.tablet;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _AppBar(ctrl: ctrl, showDrawer: showDrawer),
          drawer: showDrawer ? _MobileDrawer(ctrl: ctrl) : null,
          floatingActionButton: _ScrollTopFAB(ctrl: ctrl),
          body: SingleChildScrollView(
            controller: ctrl.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Anchor(key: ctrl.heroKey,       child: HeroSection(ctrl: ctrl)),
                _Anchor(key: ctrl.aboutKey,      child: const AboutSection()),
                _Anchor(key: ctrl.skillsKey,     child: const SkillsSection()),
                _Anchor(key: ctrl.experienceKey, child: const ExperienceSection()),
                _Anchor(key: ctrl.projectsKey,   child: const ProjectsSection()),
                _Anchor(key: ctrl.servicesKey,   child: const ServicesSection()),
                _Anchor(key: ctrl.educationKey,  child: const EducationSection()),
                _Anchor(key: ctrl.contactKey,    child: const ContactSection()),
                const FooterSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Anchor wrapper ─────────────────────────────────────────────────────────────
class _Anchor extends StatelessWidget {
  final Widget child;
  const _Anchor({required super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: double.infinity, child: child);
}

// ── AppBar ─────────────────────────────────────────────────────────────────────
class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  final HomeController ctrl;
  final bool showDrawer;
  const _AppBar({required this.ctrl, required this.showDrawer});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  bool _isDark = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDark = Theme.of(context).brightness == Brightness.dark;
  }

  void _toggleTheme() {
    final next = _isDark ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(next);
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: ShaderMask(
        shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
        child: Text(
          'Anil Kumar',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
      actions: [
        if (!widget.showDrawer) _DesktopNav(ctrl: widget.ctrl),
        IconButton(
          tooltip: _isDark ? 'Switch to Light' : 'Switch to Dark',
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey(_isDark),
            ),
          ),
          onPressed: _toggleTheme,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// ── Desktop Navigation ─────────────────────────────────────────────────────────
class _DesktopNav extends StatelessWidget {
  final HomeController ctrl;
  const _DesktopNav({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem('About',      ctrl.scrollToAbout,      1),
      _NavItem('Skills',     ctrl.scrollToSkills,     2),
      _NavItem('Experience', ctrl.scrollToExperience, 3),
      _NavItem('Projects',   ctrl.scrollToProjects,   4),
      _NavItem('Services',   ctrl.scrollToServices,   5),
      _NavItem('Contact',    ctrl.scrollToContact,    7),
    ];

    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        final active = ctrl.activeNavIndex.value == item.index;
        return _NavButton(item: item, isActive: active);
      }).toList(),
    ));
  }
}

class _NavItem {
  final String label;
  final VoidCallback action;
  final int index;
  const _NavItem(this.label, this.action, this.index);
}

class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  const _NavButton({required this.item, required this.isActive});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: active
                  ? AppColors.primary
                  : Theme.of(context).textTheme.bodyLarge?.color,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: widget.item.action,
            child: Text(
              widget.item.label,
              style: AppTextStyles.button.copyWith(
                fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mobile Drawer ──────────────────────────────────────────────────────────────
class _MobileDrawer extends StatelessWidget {
  final HomeController ctrl;
  const _MobileDrawer({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem('Home',       ctrl.scrollToHero,       0),
      _NavItem('About',      ctrl.scrollToAbout,      1),
      _NavItem('Skills',     ctrl.scrollToSkills,     2),
      _NavItem('Experience', ctrl.scrollToExperience, 3),
      _NavItem('Projects',   ctrl.scrollToProjects,   4),
      _NavItem('Services',   ctrl.scrollToServices,   5),
      _NavItem('Education',  ctrl.scrollToEducation,  6),
      _NavItem('Contact',    ctrl.scrollToContact,    7),
    ];
    final icons = [
      Icons.home_rounded, Icons.person_rounded, Icons.code_rounded,
      Icons.work_rounded, Icons.folder_rounded, Icons.design_services_rounded,
      Icons.school_rounded, Icons.contact_mail_rounded,
    ];

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text('Anil Kumar',
                  style: AppTextStyles.h4.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Flutter Developer',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          // Nav items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                return Obx(() {
                  final active = ctrl.activeNavIndex.value == items[i].index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      leading: Icon(icons[i],
                        color: active ? AppColors.primary : Colors.grey.shade600, size: 22),
                      title: Text(items[i].label,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? AppColors.primary : null,
                        ),
                      ),
                      selected: active,
                      selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      dense: true,
                      onTap: () {
                        Navigator.of(ctx).pop();
                        items[i].action();
                      },
                    ),
                  );
                });
              },
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '© ${DateTime.now().year} Anil Kumar',
              style: AppTextStyles.caption.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ── FAB ────────────────────────────────────────────────────────────────────────
class _ScrollTopFAB extends StatelessWidget {
  final HomeController ctrl;
  const _ScrollTopFAB({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: 'Back to top',
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.keyboard_arrow_up_rounded, size: 22),
      onPressed: () => ctrl.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      ),
    );
  }
}
