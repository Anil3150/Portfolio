import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/app_constants.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/modules/portfolio/controllers/portfolio_controller.dart';
import 'package:portfolio/themes/app_theme.dart';
import 'package:portfolio/widgets/glass_card.dart';
import 'package:portfolio/widgets/section_shell.dart';

class PortfolioView extends GetView<PortfolioController> {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final portfolio = controller.data.value;
      if (controller.isLoading.value || portfolio == null) {
        return const Scaffold(body: _SkeletonLoader());
      }

      return Scaffold(
        drawer: Responsive.isDesktop(context) ? null : _MobileDrawer(portfolio),
        body: Stack(
          children: [
            const _PremiumBackground(),
            CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                _Navbar(portfolio: portfolio),
                SliverToBoxAdapter(child: _HeroSection(portfolio: portfolio)),
                SliverToBoxAdapter(child: _AboutSection(portfolio: portfolio)),
                SliverToBoxAdapter(child: _SkillsSection(portfolio: portfolio)),
                SliverToBoxAdapter(
                  child: _ExperienceSection(portfolio: portfolio),
                ),
                SliverToBoxAdapter(
                  child: _ProjectsSection(portfolio: portfolio),
                ),
                SliverToBoxAdapter(
                  child: _EducationSection(portfolio: portfolio),
                ),
                SliverToBoxAdapter(
                  child: _ServicesSection(portfolio: portfolio),
                ),
                SliverToBoxAdapter(
                  child: _TestimonialsSection(portfolio: portfolio),
                ),
                SliverToBoxAdapter(
                  child: _ContactSection(portfolio: portfolio),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 36)),
              ],
            ),
            const Positioned(right: 18, bottom: 18, child: _BackToTopButton()),
          ],
        ),
      );
    });
  }
}

class _Navbar extends GetView<PortfolioController> {
  const _Navbar({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor.withOpacity(.86),
      surfaceTintColor: Colors.transparent,
      toolbarHeight: isDesktop ? 78 : 66,
      titleSpacing: 20,
      title: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.maxContentWidth,
        ),
        child: Row(
          children: [
            _Logo(name: portfolio.profile.name),
            const Spacer(),
            if (isDesktop)
              ...List.generate(
                controller.navItems.length,
                (index) => Obx(
                  () => TextButton(
                    onPressed: () => controller.scrollToSection(index),
                    child: Text(
                      controller.navItems[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color:
                            controller.selectedNavIndex.value == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(.74),
                      ),
                    ),
                  ),
                ),
              ),
            if (isDesktop) const SizedBox(width: 8),
            IconButton(
              tooltip: 'Download CV',
              onPressed: controller.downloadCv,
              icon: const Icon(Icons.download_rounded),
            ),
            IconButton(
              tooltip: 'Switch theme',
              onPressed: controller.toggleTheme,
              icon: Obx(
                () => Icon(
                  controller.isDarkMode.value
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
              ),
            ),
            if (!isDesktop)
              Builder(
                builder:
                    (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu_rounded),
                    ),
              ),
          ],
        ),
      ),
    );
  }

}

class _MobileDrawer extends GetView<PortfolioController> {
  const _MobileDrawer(this.portfolio);

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _Logo(name: portfolio.profile.name),
            const SizedBox(height: 20),
            ...List.generate(
              controller.navItems.length,
              (index) => ListTile(
                title: Text(controller.navItems[index]),
                onTap: () {
                  Get.back();
                  controller.scrollToSection(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends GetView<PortfolioController> {
  const _HeroSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    final profile = portfolio.profile;
    final isMobile = Responsive.isMobile(context);
    final heroContent = [
      Expanded(flex: isMobile ? 0 : 6, child: _HeroCopy(profile: profile)),
      SizedBox(width: isMobile ? 0 : 36, height: isMobile ? 30 : 0),
      Expanded(flex: isMobile ? 0 : 4, child: _ProfileVisual(profile: profile)),
    ];

    return Container(
      key: controller.sectionKeys[0],
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, isMobile ? 44 : 82, 20, 70),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child:
              isMobile
                  ? Column(children: heroContent)
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: heroContent,
                  ),
        ),
      ),
    );
  }
}

class _HeroCopy extends GetView<PortfolioController> {
  const _HeroCopy({required this.profile});

  final PortfolioProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Pill(
          text:
              '${profile.yearsOfExperience.toStringAsFixed(0)} years experience',
        ),
        const SizedBox(height: 22),
        Text(
          profile.name,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1.02,
          ),
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -.06),
        const SizedBox(height: 16),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            pause: 900.ms,
            animatedTexts:
                profile.roles.map((role) => TyperAnimatedText(role)).toList(),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          profile.summary,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.72),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: controller.downloadCv,
              icon: const Icon(Icons.download_rounded),
              label: const Text('Download CV'),
            ),
            OutlinedButton.icon(
              onPressed: () => controller.launchEmail(profile.email),
              icon: const Icon(Icons.mail_outline_rounded),
              label: const Text('Get in touch'),
            ),
            OutlinedButton.icon(
              onPressed: () => controller.launchExternal(profile.linkedIn),
              icon: const Icon(Icons.work_outline_rounded),
              label: const Text('LinkedIn'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileVisual extends StatelessWidget {
  const _ProfileVisual({required this.profile});

  final PortfolioProfile profile;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: .88,
              child: Image.asset(profile.profileImage, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _Metric(label: 'Projects', value: '5+')),
              Expanded(child: _Metric(label: 'Platforms', value: '4')),
              Expanded(child: _Metric(label: 'Stack', value: 'GetX')),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 650.ms).scale(begin: const Offset(.96, .96));
  }
}

class _AboutSection extends GetView<PortfolioController> {
  const _AboutSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      sectionKey: controller.sectionKeys[1],
      title: 'About',
      subtitle:
          'Career summary and professional highlights generated from the resume.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 820;
          final children = [
            Expanded(
              flex: isWide ? 5 : 0,
              child: GlassCard(
                child: Text(
                  portfolio.profile.summary,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.75),
                ),
              ),
            ),
            SizedBox(width: isWide ? 20 : 0, height: isWide ? 0 : 20),
            Expanded(
              flex: isWide ? 4 : 0,
              child: Column(
                children:
                    portfolio.highlights
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.auto_awesome_rounded,
                                    color: AppTheme.amber,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(item)),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ];
          return isWide
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              )
              : Column(children: children);
        },
      ),
    );
  }
}

class _SkillsSection extends GetView<PortfolioController> {
  const _SkillsSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      sectionKey: controller.sectionKeys[2],
      title: 'Skills',
      subtitle: 'Categorized technologies with animated capability indicators.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth > 980 ? 2 : 1;
          return GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: constraints.maxWidth > 980 ? 2.45 : 1.62,
            children:
                portfolio.skillCategories
                    .map((category) => _SkillCard(category: category))
                    .toList(),
          );
        },
      ),
    );
  }
}

class _ExperienceSection extends GetView<PortfolioController> {
  const _ExperienceSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      sectionKey: controller.sectionKeys[3],
      title: 'Experience',
      subtitle:
          'Animated timeline of roles, responsibilities, and achievements.',
      child: Column(
        children:
            portfolio.experiences
                .map((experience) => _TimelineItem(experience: experience))
                .toList(),
      ),
    );
  }
}

class _ProjectsSection extends GetView<PortfolioController> {
  const _ProjectsSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      sectionKey: controller.sectionKeys[4],
      title: 'Projects',
      subtitle: 'Dynamic project cards loaded from parsed resume data.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns =
              constraints.maxWidth > 1040
                  ? 3
                  : constraints.maxWidth > 680
                  ? 2
                  : 1;
          return GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: columns == 1 ? 1.05 : .88,
            children:
                portfolio.projects
                    .map((project) => _ProjectCard(project))
                    .toList(),
          );
        },
      ),
    );
  }
}

class _EducationSection extends GetView<PortfolioController> {
  const _EducationSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      sectionKey: controller.sectionKeys[5],
      title: 'Education & Certifications',
      subtitle: 'Academic background and verified learning signals.',
      child: Wrap(
        spacing: 18,
        runSpacing: 18,
        children: [
          ...portfolio.education.map(
            (item) => _InfoCard(
              icon: Icons.school_rounded,
              title: item.degree,
              subtitle: item.institution,
              meta: item.duration,
            ),
          ),
          ...portfolio.certifications.map(
            (item) => _InfoCard(
              icon: Icons.workspace_premium_rounded,
              title: item.title,
              subtitle: item.issuer,
              meta: item.date.isEmpty ? 'Certification' : item.date,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesSection extends GetView<PortfolioController> {
  const _ServicesSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.phone_iphone_rounded,
      Icons.hub_rounded,
      Icons.design_services_rounded,
      Icons.notifications_active_rounded,
      Icons.api_rounded,
    ];
    return SectionShell(
      sectionKey: controller.sectionKeys[6],
      title: 'Services',
      subtitle: 'What this portfolio can position Anil for.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns =
              constraints.maxWidth > 960
                  ? 3
                  : constraints.maxWidth > 620
                  ? 2
                  : 1;
          return GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: columns == 1 ? 2.65 : 1.55,
            children: List.generate(
              portfolio.services.length,
              (index) => _ServiceCard(
                service: portfolio.services[index],
                icon: icons[index % icons.length],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TestimonialsSection extends GetView<PortfolioController> {
  const _TestimonialsSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      sectionKey: controller.sectionKeys[7],
      title: 'Testimonials',
      subtitle: 'Carousel-ready proof points for portfolio credibility.',
      child: SizedBox(
        height: 210,
        child: PageView(
          controller: PageController(
            viewportFraction: Responsive.isMobile(context) ? .96 : .54,
          ),
          children:
              portfolio.testimonials
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.format_quote_rounded,
                              size: 34,
                              color: AppTheme.rose,
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Text(
                                item.quote,
                                style: const TextStyle(height: 1.55),
                              ),
                            ),
                            Text(
                              item.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(item.role),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _ContactSection extends GetView<PortfolioController> {
  const _ContactSection({required this.portfolio});

  final PortfolioData portfolio;

  @override
  Widget build(BuildContext context) {
    final profile = portfolio.profile;
    return SectionShell(
      sectionKey: controller.sectionKeys[8],
      title: 'Contact',
      subtitle: 'Contact form, direct links, WhatsApp, and location actions.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 850;
          final form = GlassCard(
            child: Column(
              children: [
                const TextField(decoration: InputDecoration(labelText: 'Name')),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                const TextField(
                  minLines: 4,
                  maxLines: 6,
                  decoration: InputDecoration(labelText: 'Message'),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.launchEmail(profile.email),
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Send message'),
                  ),
                ),
              ],
            ),
          );
          final actions = GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContactTile(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  value: profile.email,
                  onTap: () => controller.launchEmail(profile.email),
                ),
                _ContactTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: profile.phone,
                  onTap: () => controller.launchPhone(profile.phone),
                ),
                _ContactTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'WhatsApp',
                  value: profile.phone,
                  onTap: () => controller.launchWhatsApp(profile.phone),
                ),
                _ContactTile(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: profile.location,
                  onTap:
                      () => controller.launchExternal(
                        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(profile.location)}',
                      ),
                ),
              ],
            ),
          );
          return isWide
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: form),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: actions),
                ],
              )
              : Column(children: [form, const SizedBox(height: 20), actions]);
        },
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.category});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              minHeight: 9,
              value: category.strength,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(.08),
            ),
          ).animate().scaleX(duration: 800.ms, alignment: Alignment.centerLeft),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                category.skills.map((skill) => _Pill(text: skill)).toList(),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.experience});

  final ExperienceItem experience;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(.4),
                      blurRadius: 18,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Theme.of(context).colorScheme.primary.withOpacity(.3),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.role,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${experience.company} - ${experience.location}'),
                    const SizedBox(height: 4),
                    _Pill(text: experience.duration),
                    const SizedBox(height: 16),
                    ...experience.achievements.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: AppTheme.mint,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard(this.project);

  final ProjectItem project;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [AppTheme.cyan, AppTheme.mint],
                  ),
                ),
                child: const Icon(Icons.apps_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  project.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            project.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                project.technologies.map((tech) => _Pill(text: tech)).toList(),
          ),
          const Spacer(),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: project.githubUrl.isEmpty ? null : () {},
                icon: const Icon(Icons.code_rounded, size: 18),
                label: const Text('GitHub'),
              ),
              OutlinedButton.icon(
                onPressed: project.demoUrl.isEmpty ? null : () {},
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Demo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.meta,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 10),
            _Pill(text: meta),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.icon});

  final ServiceItem service;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 30),
          const SizedBox(height: 14),
          Text(
            service.title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text(service.description),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(value),
      onTap: onTap,
    );
  }
}

class _BackToTopButton extends GetView<PortfolioController> {
  const _BackToTopButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () => controller.scrollToSection(0),
      child: const Icon(Icons.keyboard_arrow_up_rounded),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(.18),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials =
        name
            .split(' ')
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part[0])
            .join()
            .toUpperCase();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppTheme.cyan, AppTheme.mint],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cyan.withOpacity(.28),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Portfolio',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _PremiumBackground extends StatelessWidget {
  const _PremiumBackground();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? const [
                      Color(0xFF0B1020),
                      Color(0xFF122033),
                      Color(0xFF101827),
                    ]
                    : const [
                      Color(0xFFF8FBFF),
                      Color(0xFFEFF6FF),
                      Color(0xFFF7FDF9),
                    ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  const _SkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
