import 'package:flutter/widgets.dart';

import 'app_constants.dart';

enum DeviceScreenType { mobile, tablet, desktop }

class Responsive {
  const Responsive._();

  static DeviceScreenType typeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < AppConstants.mobileBreakpoint) return DeviceScreenType.mobile;
    if (width < AppConstants.tabletBreakpoint) return DeviceScreenType.tablet;
    return DeviceScreenType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      typeOf(context) == DeviceScreenType.mobile;

  static bool isDesktop(BuildContext context) =>
      typeOf(context) == DeviceScreenType.desktop;
}
