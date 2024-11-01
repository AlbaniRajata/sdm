import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget tabletDesktopLayout;

  const ResponsiveLayout({
    required this.mobileLayout,
    required this.tabletDesktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return mobileLayout;
    } else {
      return tabletDesktopLayout;
    }
  }
}
