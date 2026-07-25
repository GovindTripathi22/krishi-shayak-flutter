import 'package:flutter/material.dart';
import 'screen_utils.dart';

/// ResponsiveLayout Widget for adaptively displaying layouts across Small Phones, Phones, and Tablets
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? smallMobileBody;
  final Widget? tabletBody;
  final Widget? landscapeBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.smallMobileBody,
    this.tabletBody,
    this.landscapeBody,
  });

  @override
  Widget build(BuildContext context) {
    if (ScreenUtils.isLandscape(context) && landscapeBody != null) {
      return landscapeBody!;
    }
    if (ScreenUtils.isTablet(context) && tabletBody != null) {
      return tabletBody!;
    }
    if (ScreenUtils.isSmallPhone(context) && smallMobileBody != null) {
      return smallMobileBody!;
    }
    return mobileBody;
  }
}
