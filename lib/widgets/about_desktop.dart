import 'package:flutter/widgets.dart';

import '../constants/colors.dart';

class AboutDesktop extends StatelessWidget {
  const AboutDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'About Me',
            style: TextStyle(
              color: Colorss.whitePrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Optional image or spacer on left
              Expanded(flex: 1, child: SizedBox()),

              // About Text
              Expanded(
                flex: 2,
                child: Text(
                  '''I'm Anil Kumar Malipeddi, a Flutter Developer with 1.5 years of experience in cross-platform mobile app development. I specialize in building scalable, high-performance applications using Flutter and Dart, with expertise in state management (GetX), UI/UX design, and backend integration.

Currently, I work at HashStack Solutions Pvt Ltd, where I develop dynamic and user-friendly mobile applications. My areas of expertise include REST APIs, native platform integrations, and performance optimization.

Passionate about mobile development, I enjoy solving real-world problems with intuitive and efficient app solutions.''',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, color: Colorss.whiteSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
