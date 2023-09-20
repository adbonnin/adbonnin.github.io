import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

const _defaultZoomLevel = 1.0;
const _defaultCameraAvailable = true;

// https://medium.com/@fernnandoptr/how-to-use-camera-in-flutter-flutter-camera-package-44defe81d2da
// https://github.com/khoren93/flutter_zxing/blob/main/lib/src/ui/reader_widget.dart
class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    this.onImageAvailable,
    this.initialLensDirection = CameraLensDirection.back,
  });

  final onLatestImageAvailable? onImageAvailable;
  final CameraLensDirection initialLensDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  List<CameraDescription> _cameras = <CameraDescription>[];
  CameraController? _controller;

  bool _isCameraInitialized = false;
  bool _isFlashAvailable = _defaultCameraAvailable;

  FlashMode _flashMode = FlashMode.off;
  double _zoomLevel = _defaultZoomLevel;
  double _minZoomLevel = _defaultZoomLevel;
  double _maxZoomLevel = _defaultZoomLevel;

  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  Future<void> _asyncInitState() async {
    availableCameras().then((cameras) {
      _cameras = cameras;

      if (cameras.isNotEmpty) {
        final selectedCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == widget.initialLensDirection,
          orElse: () => cameras.first,
        );

        _updateSelectedCamera(selectedCamera);
      }
    });
  }

  @override
  void dispose() {
    _disposeCamera(_controller);
    super.dispose();
  }

  Future<void> _disposeCamera(CameraController? controller) async {
    if (controller != null) {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }

      await controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCameraReady = _cameras.isNotEmpty && //
        _isCameraInitialized &&
        _controller != null &&
        _controller!.value.isInitialized;

    return Stack(
      children: [
        if (!isCameraReady) //
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (isCameraReady) //
          CameraPreview(_controller!)
      ],
    );
  }

  Future<void> _updateSelectedCamera(CameraDescription camera) async {
    final oldController = _controller;

    if (oldController != null) {
      _controller = null;
      _isCameraInitialized = false;
      await _disposeCamera(oldController);
    }

    final cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller = cameraController;

    try {
      await cameraController.initialize();
    } //
    on CameraException catch (e) {
      debugPrint('${e.code}: ${e.description}');
    } //
    catch (e) {
      debugPrint('Error: $e');
    }

    if (widget.onImageAvailable != null) {
      try {
        await cameraController.startImageStream(widget.onImageAvailable!);
      } //
      catch (e) {
        debugPrint('Error: $e');
      }
    }

    var cameraMinZoomLevel = _defaultZoomLevel;
    var cameraMaxZoomLevel = _defaultZoomLevel;
    try {
      final minZoomLevelFuture = cameraController //
          .getMinZoomLevel()
          .then((level) => cameraMinZoomLevel = level);

      final maxZoomLevelFuture = cameraController //
          .getMaxZoomLevel()
          .then((level) => cameraMaxZoomLevel = level);

      await Future.wait([minZoomLevelFuture, maxZoomLevelFuture]);
    } //
    catch (e) {
      debugPrint('Error: $e');
    }

    var isCameraFlashAvailable = _defaultCameraAvailable;
    try {
      await cameraController.setFlashMode(_flashMode);
    } //
    catch (e) {
      isCameraFlashAvailable = false;
      debugPrint('Error: $e');
    }

    if (mounted) {
      setState(() {
        if (_controller == cameraController) {
          _minZoomLevel = _zoomLevel = cameraMinZoomLevel;
          _maxZoomLevel = cameraMaxZoomLevel;
          _isFlashAvailable = isCameraFlashAvailable;

          if (!isCameraFlashAvailable) {
            _flashMode = FlashMode.off;
          }

          // _isCameraInitialized = true;
        }
      });
    }
  }
}
