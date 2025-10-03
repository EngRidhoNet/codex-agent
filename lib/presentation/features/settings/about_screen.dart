/// About screen describing the AURA+ project.
import 'package:flutter/material.dart';

import '../../common/widgets/app_scaffold.dart';

/// Simple about page widget.
class AboutScreen extends StatelessWidget {
  /// Creates the about screen.
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'About AURA+',
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'AURA+ membantu terapi berbasis AR dengan konten offline dan evaluasi pelafalan. '
          'Gunakan perangkat dengan dukungan AR untuk pengalaman terbaik.',
        ),
      ),
    );
  }
}
