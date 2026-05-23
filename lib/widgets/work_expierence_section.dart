import 'package:flutter/material.dart';

class WorkExperienceSection extends StatelessWidget {
  final double screenWidth;
  final bool isDesktop;

  const WorkExperienceSection({
    super.key,
    required this.screenWidth,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 60),
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isDesktop ? _workExperienceDesktop() : _workExperienceMobile(),
        ],
      ),
    );
  }

  Widget _workExperienceDesktop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _experienceCard(
            icon: Icons.phone_iphone,
            title: 'Flutter Developer',
            company: 'Hashstack Solutions',
            duration: 'Aug 2025 - Present',
            description:
                'Developed and maintained high-quality mobile applications using Flutter and GetX, implemented REST APIs, and optimized UI performance.',
          ),
        ),
      ],
    );
  }

  Widget _workExperienceMobile() {
    return Column(
      children: [
        _experienceCard(
          icon: Icons.phone_iphone,
          title: 'Flutter Developer',
          company: 'HashStack Solutions',
          duration: 'Aug 2025 - Present',
          description:
              'Developed and maintained high-quality mobile applications using Flutter and GetX, implemented REST APIs, and optimized UI performance.',
        ),
      ],
    );
  }

  Widget _experienceCard({
    required IconData icon,
    required String title,
    required String company,
    required String duration,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent.withOpacity(0.3), Colors.purpleAccent.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white24,
                radius: 24,
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.business, size: 18, color: Colors.white70),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  company,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.white54),
              const SizedBox(width: 6),
              Text(
                duration,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white60,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
