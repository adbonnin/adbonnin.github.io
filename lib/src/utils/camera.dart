import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

// https://pub.dev/packages/google_mlkit_commons#usage
// https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/camera_view.dart
InputImage? toInputImage(CameraImage image, InputImageRotation rotation, InputImageFormat format) {
  final plane = image.planes.firstOrNull;

  if (plane == null) {
    return null;
  }

  final metadata = InputImageMetadata(
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rotation: rotation,
    format: format,
    bytesPerRow: plane.bytesPerRow,
  );

  return InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: metadata,
  );
}

InputImageRotation? getRotation(CameraDescription camera, CameraController controller) {
  final sensorOrientation = camera.sensorOrientation;
  final lensDirection = camera.lensDirection;
  final deviceOrientation = controller.value.deviceOrientation;

  if (Platform.isIOS) {
    return InputImageRotationValue.fromRawValue(sensorOrientation);
  }

  if (Platform.isAndroid) {
    var rotationCompensation = _orientations[deviceOrientation];

    if (rotationCompensation == null) {
      return null;
    }

    if (lensDirection == CameraLensDirection.front) {
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } //
    else {
      rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
    }

    return InputImageRotationValue.fromRawValue(rotationCompensation);
  }

  return null;
}
