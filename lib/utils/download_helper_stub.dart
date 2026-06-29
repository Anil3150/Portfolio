import 'package:url_launcher/url_launcher.dart';

Future<void> downloadAsset(String assetPath, String fileName) async {
  final uri = Uri.parse(assetPath);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not open $fileName');
  }
}
