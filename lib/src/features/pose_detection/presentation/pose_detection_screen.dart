import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/widgets/camera_view.dart';

// https://medium.com/@inzimamb5/pose-detector-using-google-ml-kit-in-flutter-getx-ea3bf9bb62ff
class PoseDetectionScreen extends StatelessWidget {
  const PoseDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CameraView(
      onImageAvailable: _processImage,
    );
  }

  void _processImage(CameraImage image) {}
}
