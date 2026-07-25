import 'package:flutter/material.dart';

enum DeviceType { smallPhone, phone, tablet }

class ScreenUtils {
  static const double smallPhoneWidthBreakpoint = 360.0;
  static const double tabletWidthBreakpoint = 600.0;

  static DeviceType getDeviceType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < smallPhoneWidthBreakpoint) {
      return DeviceType.smallPhone;
    } else if (width >= tabletWidthBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.phone;
    }
  }

  static bool isTablet(BuildContext context) => getDeviceType(context) == DeviceType.tablet;
  static bool isSmallPhone(BuildContext context) => getDeviceType(context) == DeviceType.smallPhone;
  static bool isLandscape(BuildContext context) => MediaQuery.of(context).orientation == Orientation.landscape;

  static double responsiveFontSize(BuildContext context, double baseFontSize) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.smallPhone:
        return baseFontSize * 0.9;
      case DeviceType.tablet:
        return baseFontSize * 1.25;
      case DeviceType.phone:
      default:
        return baseFontSize;
    }
  }

  static EdgeInsets responsivePadding(BuildContext context) {
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0);
    } else if (isSmallPhone(context)) {
      return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
    }
  }
}
