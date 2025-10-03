/// Standalone 3D model viewer with optional AR placement.
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../common/widgets/app_scaffold.dart';

/// Simple AR viewer screen.
class ArViewerScreen extends StatelessWidget {
  /// Creates the viewer screen.
  const ArViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Model Viewer',
      body: Column(
        children: const [
          Expanded(
            child: ModelViewer(
              src: 'assets/models/cat.glb',
              ar: true,
              autoRotate: true,
              cameraControls: true,
              loading: Center(child: CircularProgressIndicator()),
            ),
          ),
          SizedBox(height: 16),
          Text('Tap tombol AR di pojok kanan bawah viewer untuk mencoba penempatan AR.'),
        ],
      ),
    );
  }
}
