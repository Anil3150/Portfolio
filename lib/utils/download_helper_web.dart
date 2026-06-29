import 'dart:html' as html;

Future<void> downloadAsset(String assetPath, String fileName) async {
  final anchor =
      html.AnchorElement(href: assetPath)
        ..download = fileName
        ..style.display = 'none';

  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
