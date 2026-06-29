import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../constants/contact_items.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      color: Colorss.bgLight1,
      child: Column(
        children: [
          const Text(
            "Get In Touch",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colorss.whitePrimary,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "I am always open to discussing new projects, creative ideas or opportunities to be part of your vision.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colorss.whiteSecondary,
            ),
          ),

          const SizedBox(height: 30),

          Wrap(
            spacing: 25,
            runSpacing: 25,
            alignment: WrapAlignment.center,
            children: List.generate(contactTitles.length, (index) {
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => launchContact(contactActions[index]),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colorss.bgLight2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        contactIcons[index],
                        color: Colorss.whitePrimary,
                        size: 22,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        contactTitles[index],
                        style: const TextStyle(
                          color: Colorss.whiteSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

Future<void> launchContact(String url) async {
  final Uri uri = Uri.parse(url);

  try {
    if (kIsWeb) {
      await launchUrl(
        uri,
        webOnlyWindowName: '_blank',
      );
    } else {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  } catch (e) {
    debugPrint("Launch Error: $e");
  }
}