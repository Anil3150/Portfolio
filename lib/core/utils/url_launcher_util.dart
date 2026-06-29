import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches a URL in the most reliable way for the current platform.
/// On web, uses [LaunchMode.platformDefault] to open in a new tab (respects browser policies).
/// On native, uses [LaunchMode.externalApplication] to open the system browser.
Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  final mode = kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication;
  try {
    final launched = await launchUrl(uri, mode: mode);
    if (!launched) {
      debugPrint('[openUrl] launchUrl returned false for: $url');
    }
  } catch (e) {
    debugPrint('[openUrl] Error launching $url: $e');
  }
}
