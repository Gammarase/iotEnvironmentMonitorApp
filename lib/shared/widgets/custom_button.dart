import 'package:flutter/material.dart';

/// Custom primary button
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                )
              : Text(label),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

/// Custom outlined button
class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final IconData? icon;

  const CustomOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(label),
              ],
            )
          : Text(label),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

/// Custom text button
class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  const CustomTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: color != null
          ? TextButton.styleFrom(foregroundColor: color)
          : null,
      child: Text(label),
    );
  }
}
