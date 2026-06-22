import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class BrutalButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Widget? trailingIcon;
  final bool isFullWidth;

  const BrutalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppTheme.primaryBlue,
    this.textColor = AppTheme.pureWhite,
    this.trailingIcon,
    this.isFullWidth = true,
  });

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Text(
          widget.text.toUpperCase(),
          style: TextStyle(
            color: widget.textColor,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: 8),
          widget.trailingIcon!,
        ]
      ],
    );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(
          top: _isPressed ? AppTheme.shadowOffset : 0,
          left: _isPressed ? AppTheme.shadowOffset : 0,
        ),
        decoration: AppTheme.brutalBox(
          bgColor: widget.backgroundColor,
          shadow: !_isPressed, // Remove shadow when pressed
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        child: buttonContent,
      ),
    );
  }
}
