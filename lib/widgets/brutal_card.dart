import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BrutalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const BrutalCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.backgroundColor = AppTheme.pureWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.brutalBox(bgColor: backgroundColor),
      padding: padding,
      child: child,
    );
  }
}
