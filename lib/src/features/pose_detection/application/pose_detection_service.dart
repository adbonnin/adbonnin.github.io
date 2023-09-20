import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pose_detection_service.g.dart';

@Riverpod(keepAlive: true)
PoseDetectionService poseDetectionService(PoseDetectionServiceRef ref) {
  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(),
  );

  return PoseDetectionService(poseDetector);
}

class PoseDetectionService {
  PoseDetectionService(this.poseDetector);

  final PoseDetector poseDetector;

  Future<List<Pose>> processImage(InputImage inputImage) {
    return poseDetector.processImage(inputImage);
  }
}
