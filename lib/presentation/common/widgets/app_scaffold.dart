/// Shared scaffold widget applying consistent padding and background.
import 'package:flutter/material.dart';

/// Reusable scaffold with safe-area padding for therapy friendly UI.
class AppScaffold extends StatelessWidget {
  /// Builds the scaffold with [title] and [body].
  const AppScaffold({super.key, required this.title, required this.body, this.actions});

  /// Page title.
  final String title;

  /// Content widget.
  final Widget body;

  /// Optional action widgets for the app bar.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: body,
        ),
      ),
    );
  }
}
