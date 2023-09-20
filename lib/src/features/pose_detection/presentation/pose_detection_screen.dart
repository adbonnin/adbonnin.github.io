import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:portfolio/src/features/pose_detection/application/pose_detection_service.dart';
import 'package:portfolio/src/utils/camera.dart';
import 'package:portfolio/src/widgets/camera_view.dart';

// https://medium.com/@inzimamb5/pose-detector-using-google-ml-kit-in-flutter-getx-ea3bf9bb62ff
// https://pub.dev/packages/google_mlkit_commons#usage
class PoseDetectionScreen extends ConsumerStatefulWidget {
  const PoseDetectionScreen({super.key});

  @override
  ConsumerState<PoseDetectionScreen> createState() => _PoseDetectionScreenState();
}

class _PoseDetectionScreenState extends ConsumerState<PoseDetectionScreen> {
  var isProcessing = false;
  CustomPainter? posePainter;

  @override
  Widget build(BuildContext context) {
    return CameraView(
      onImageAvailable: _processImage,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
  }

  Future<void> _processImage(CameraDescription camera, CameraController controller, CameraImage image) async {
    if (isProcessing) {
      return;
    }

    isProcessing = true;
    try {
      final inputImage = _toInputImage(camera, controller, image);

      if (inputImage == null) {
        return;
      }

      final poses = await ref.read(poseDetectionServiceProvider).processImage(inputImage);

      final metadata = inputImage.metadata;
      posePainter = PosePainter(poses, metadata.size, metadata.rotation);
    } //
    finally {
      isProcessing = false;
    }
  }

  InputImage? _toInputImage(CameraDescription camera, CameraController controller, CameraImage image) {
    final rotation = getRotation(camera, controller);

    if (rotation == null) {
      return null;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null || //
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    return toInputImage(image, rotation, format);
  }
}
