import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../constants/contact_items.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 60),
      color: Colorss.bgLight1,
      child: Column(
        children: [
          Text(
            'Get In Touch',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colorss.whitePrimary,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'I am always open to discussing new projects, creative ideas or opportunities to be part of your vision.',
            style: TextStyle(fontSize: 16, color: Colorss.whiteSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Wrap(
            runSpacing: 25,
            spacing: 25,
            children: [
              for (int i = 0; i < contactTitles.length; i++)
                InkWell(
                  onTap: () async {
                    launchContact(contactTitles[i], contactActions[i]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colorss.bgLight2,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          contactIcons[i],
                          color: Colorss.whitePrimary,
                          size: 20,
                        ),
                        SizedBox(height: 5),
                        Text(
                          contactTitles[i],
                          style: TextStyle(
                            color: Colorss.whiteSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> launchContact(String type, String value) async {
  Uri uri;

  switch (type.toLowerCase()) {
    case 'phone':
      uri = Uri.parse("tel:$value");
      break;

    case 'email':
      uri = Uri.parse("mailto:$value");
      break;

    case 'linkedin':
      uri = Uri.parse(value);
      break;

    default:
      print("Unsupported contact type: $type");
      return;
  }

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      // ✅ Fallback for email (open Gmail in browser)
      if (type.toLowerCase() == 'email') {
        final Uri webMail = Uri.parse(
          "https://mail.google.com/mail/?view=cm&to=$value",
        );
        if (await canLaunchUrl(webMail)) {
          await launchUrl(webMail, mode: LaunchMode.externalApplication);
          return;
        }
      }

      // ✅ Fallback for LinkedIn (open in browser)
      if (type.toLowerCase() == 'linkedin') {
        final Uri linkedInWeb = Uri.parse(value);
        if (await canLaunchUrl(linkedInWeb)) {
          await launchUrl(linkedInWeb, mode: LaunchMode.externalApplication);
          return;
        }
      }

      throw 'Could not launch $uri';
    }
  } catch (e) {
    print("Error launching $type: $e");
  }
}
