/// Card summarising progress information with accessible visuals.
import 'package:flutter/material.dart';

/// Displays progress percentage with description.
class CardProgress extends StatelessWidget {
  /// Creates the progress card.
  const CardProgress({super.key, required this.title, required this.progress});

  /// Title text.
  final String title;

  /// Progress ratio between 0 and 1.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress.clamp(0, 1)),
            const SizedBox(height: 8),
            Text('${(progress * 100).toStringAsFixed(0)}%'),
          ],
        ),
      ),
    );
  }
}
