import 'package:flutter/material.dart';

/// Responsive breakpoints (width-based)
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double maxContent = 1280; // max-width for web centering
}

/// Responsive spacing tokens
class AppSpacing {
  // Horizontal section padding
  static double sectionH(double width) {
    if (width < AppBreakpoints.mobile) return 20;
    if (width < AppBreakpoints.tablet) return 48;
    return 80;
  }

  // Vertical section padding
  static double sectionV(double width) {
    if (width < AppBreakpoints.mobile) return 56;
    if (width < AppBreakpoints.tablet) return 72;
    return 96;
  }

  // Card inner padding
  static double cardPad(double width) {
    if (width < AppBreakpoints.mobile) return 20;
    if (width < AppBreakpoints.tablet) return 28;
    return 32;
  }

  // Gap between grid items
  static double gridGap(double width) {
    if (width < AppBreakpoints.mobile) return 16;
    if (width < AppBreakpoints.tablet) return 24;
    return 32;
  }
}

/// Layout type
enum LayoutType { mobile, tablet, desktop }

extension LayoutTypeExt on double {
  LayoutType get layoutType {
    if (this < AppBreakpoints.mobile) return LayoutType.mobile;
    if (this < AppBreakpoints.tablet) return LayoutType.tablet;
    return LayoutType.desktop;
  }

  bool get isMobile => this < AppBreakpoints.mobile;
  bool get isTablet => this >= AppBreakpoints.mobile && this < AppBreakpoints.tablet;
  bool get isDesktop => this >= AppBreakpoints.tablet;
}
