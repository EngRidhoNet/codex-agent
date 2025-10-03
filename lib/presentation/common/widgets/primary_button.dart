/// Primary CTA button used across the experience.
import 'package:flutter/material.dart';

/// Rounded elevated button emphasising calm visuals.
class PrimaryButton extends StatelessWidget {
  /// Creates the button with [label] and [onPressed].
  const PrimaryButton({super.key, required this.label, this.onPressed});

  /// Button label.
  final String label;

  /// Press callback.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}
