import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Provider for [CameraService] dependency injection
final cameraServiceProvider = Provider<CameraService>((ref) {
  final service = CameraService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

/// Camera state data class for reactive state updates
class CameraStateData {
  final bool isInitialized;
  final bool isPermissionGranted;
  final bool isInitializing;
  final bool isRecordingVideo;
  final bool isRecordingPaused;
  final bool isStreamingFrames;
  final String? errorMessage;
  final List<CameraDescription> availableCameras;
  final int selectedCameraIndex;
  final FlashMode flashMode;
  final double currentZoom;
  final double minZoom;
  final double maxZoom;
  final FocusMode focusMode;

  const CameraStateData({
    this.isInitialized = false,
    this.isPermissionGranted = false,
    this.isInitializing = false,
    this.isRecordingVideo = false,
    this.isRecordingPaused = false,
    this.isStreamingFrames = false,
    this.errorMessage,
    this.availableCameras = const [],
    this.selectedCameraIndex = 0,
    this.flashMode = FlashMode.off,
    this.currentZoom = 1.0,
    this.minZoom = 1.0,
    this.maxZoom = 1.0,
    this.focusMode = FocusMode.auto,
  });

  CameraStateData copyWith({
    bool? isInitialized,
    bool? isPermissionGranted,
    bool? isInitializing,
    bool? isRecordingVideo,
    bool? isRecordingPaused,
    bool? isStreamingFrames,
    String? errorMessage,
    List<CameraDescription>? availableCameras,
    int? selectedCameraIndex,
    FlashMode? flashMode,
    double? currentZoom,
    double? minZoom,
    double? maxZoom,
    FocusMode? focusMode,
  }) {
    return CameraStateData(
      isInitialized: isInitialized ?? this.isInitialized,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      isInitializing: isInitializing ?? this.isInitializing,
      isRecordingVideo: isRecordingVideo ?? this.isRecordingVideo,
      isRecordingPaused: isRecordingPaused ?? this.isRecordingPaused,
      isStreamingFrames: isStreamingFrames ?? this.isStreamingFrames,
      errorMessage: errorMessage,
      availableCameras: availableCameras ?? this.availableCameras,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      flashMode: flashMode ?? this.flashMode,
      currentZoom: currentZoom ?? this.currentZoom,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      focusMode: focusMode ?? this.focusMode,
    );
  }
}

/// Service providing production-ready Flutter Camera hardware management.
class CameraService {
  CameraController? _controller;
  CameraStateData _state = const CameraStateData();

  final ValueNotifier<CameraStateData> stateNotifier =
      ValueNotifier<CameraStateData>(const CameraStateData());

  CameraController? get controller => _controller;
  CameraStateData get state => _state;

  void _updateState(CameraStateData newState) {
    _state = newState;
    stateNotifier.value = newState;
  }

  /// Request camera hardware permissions cross-platform
  Future<bool> requestCameraPermission() async {
    try {
      if (kIsWeb) {
        _updateState(_state.copyWith(isPermissionGranted: true));
        return true;
      }

      final status = await Permission.camera.request();
      final isGranted = status.isGranted;

      _updateState(_state.copyWith(
        isPermissionGranted: isGranted,
        errorMessage: isGranted ? null : "Camera permission denied by user",
      ));

      return isGranted;
    } catch (e) {
      _updateState(_state.copyWith(
        isPermissionGranted: false,
        errorMessage: "Failed to request camera permission: ${e.toString()}",
      ));
      return false;
    }
  }

  /// Initialize available hardware cameras & controller
  Future<void> initialize({CameraLensDirection preferredDirection = CameraLensDirection.back}) async {
    if (_state.isInitializing) return;

    _updateState(_state.copyWith(isInitializing: true, errorMessage: null));

    try {
      final isGranted = await requestCameraPermission();
      if (!isGranted) {
        _updateState(_state.copyWith(
          isInitializing: false,
          isInitialized: false,
        ));
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _updateState(_state.copyWith(
          isInitializing: false,
          isInitialized: false,
          errorMessage: "No hardware cameras available on device",
        ));
        return;
      }

      int targetIndex = 0;
      for (int i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == preferredDirection) {
          targetIndex = i;
          break;
        }
      }

      _updateState(_state.copyWith(
        availableCameras: cameras,
        selectedCameraIndex: targetIndex,
      ));

      await _setupController(cameras[targetIndex]);
    } catch (e) {
      _updateState(_state.copyWith(
        isInitializing: false,
        isInitialized: false,
        errorMessage: "Camera initialization failed: ${e.toString()}",
      ));
    }
  }

  /// Setup CameraController for a specific [CameraDescription]
  Future<void> _setupController(CameraDescription cameraDescription) async {
    await _disposeController();

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();

      double minZoom = 1.0;
      double maxZoom = 1.0;

      try {
        minZoom = await _controller!.getMinZoomLevel();
        maxZoom = await _controller!.getMaxZoomLevel();
      } catch (_) {
        // Zoom levels unsupported on some devices/web fallback
      }

      _updateState(_state.copyWith(
        isInitialized: true,
        isInitializing: false,
        currentZoom: minZoom,
        minZoom: minZoom,
        maxZoom: maxZoom,
        errorMessage: null,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        isInitialized: false,
        isInitializing: false,
        errorMessage: "Failed to initialize camera preview: ${e.toString()}",
      ));
    }
  }

  /// Toggle between Front and Rear cameras
  Future<void> switchCamera() async {
    if (_state.availableCameras.length < 2) return;

    final nextIndex = (_state.selectedCameraIndex + 1) % _state.availableCameras.length;
    _updateState(_state.copyWith(
      selectedCameraIndex: nextIndex,
      isInitializing: true,
    ));

    await _setupController(_state.availableCameras[nextIndex]);
  }

  /// Set camera flash mode (off, torch, auto, always)
  Future<void> setFlashMode(FlashMode mode) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      await _controller!.setFlashMode(mode);
      _updateState(_state.copyWith(flashMode: mode));
    } catch (e) {
      // Flash mode may not be supported on front camera or specific platform
    }
  }

  /// Toggle flash mode between Off and Torch / Auto
  Future<void> toggleFlash() async {
    final nextMode = _state.flashMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;
    await setFlashMode(nextMode);
  }

  /// Set camera zoom level within valid bounds
  Future<void> setZoomLevel(double zoom) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final clampedZoom = zoom.clamp(_state.minZoom, _state.maxZoom);
    try {
      await _controller!.setZoomLevel(clampedZoom);
      _updateState(_state.copyWith(currentZoom: clampedZoom));
    } catch (e) {
      // Zoom setting unsupported or failed
    }
  }

  /// Set tap-to-focus point and mode
  Future<void> setFocusPoint(Offset point) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      await _controller!.setFocusMode(FocusMode.auto);
      await _controller!.setFocusPoint(point);
      _updateState(_state.copyWith(focusMode: FocusMode.auto));
    } catch (e) {
      // Focus point unsupported
    }
  }

  /// Capture high-resolution photo and return [XFile]
  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception("Camera is not initialized");
    }

    if (_controller!.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile file = await _controller!.takePicture();
      return file;
    } on CameraException catch (e) {
      _updateState(_state.copyWith(
        errorMessage: "Failed to capture photo: ${e.message}",
      ));
      return null;
    } catch (e) {
      _updateState(_state.copyWith(
        errorMessage: "Error capturing photo: ${e.toString()}",
      ));
      return null;
    }
  }

  /// Real-Time Frame Streaming: Start image stream for real-time vision processing
  Future<void> startImageStream(onFrameAvailable onFrame) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isStreamingImages) return;

    try {
      await _controller!.startImageStream(onFrame);
      _updateState(_state.copyWith(isStreamingFrames: true));
    } catch (e) {
      _updateState(_state.copyWith(
        errorMessage: "Failed to start image stream: ${e.toString()}",
      ));
    }
  }

  /// Stop real-time frame streaming
  Future<void> stopImageStream() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (!_controller!.value.isStreamingImages) return;

    try {
      await _controller!.stopImageStream();
      _updateState(_state.copyWith(isStreamingFrames: false));
    } catch (e) {
      // Ignore exception when stopping stream
    }
  }

  /// Video Capture: Start video recording
  Future<void> startVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isRecordingVideo) return;

    try {
      await _controller!.startVideoRecording();
      _updateState(_state.copyWith(
        isRecordingVideo: true,
        isRecordingPaused: false,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        errorMessage: "Failed to start video recording: ${e.toString()}",
      ));
    }
  }

  /// Pause video recording
  Future<void> pauseVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (!_controller!.value.isRecordingVideo) return;

    try {
      await _controller!.pauseVideoRecording();
      _updateState(_state.copyWith(isRecordingPaused: true));
    } catch (e) {
      // Pause unsupported or failed
    }
  }

  /// Resume video recording
  Future<void> resumeVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (!_controller!.value.isRecordingVideo) return;

    try {
      await _controller!.resumeVideoRecording();
      _updateState(_state.copyWith(isRecordingPaused: false));
    } catch (e) {
      // Resume unsupported or failed
    }
  }

  /// Stop video recording and return recorded [XFile]
  Future<XFile?> stopVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    if (!_controller!.value.isRecordingVideo) return null;

    try {
      final XFile file = await _controller!.stopVideoRecording();
      _updateState(_state.copyWith(
        isRecordingVideo: false,
        isRecordingPaused: false,
      ));
      return file;
    } catch (e) {
      _updateState(_state.copyWith(
        isRecordingVideo: false,
        isRecordingPaused: false,
        errorMessage: "Failed to stop video recording: ${e.toString()}",
      ));
      return null;
    }
  }

  /// Handle application lifecycle pause/resume
  Future<void> handleAppLifecycleState(AppLifecycleState lifecycleState) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (lifecycleState == AppLifecycleState.inactive ||
        lifecycleState == AppLifecycleState.paused) {
      await _disposeController();
      _updateState(_state.copyWith(isInitialized: false));
    } else if (lifecycleState == AppLifecycleState.resumed) {
      if (_state.availableCameras.isNotEmpty) {
        await _setupController(_state.availableCameras[_state.selectedCameraIndex]);
      }
    }
  }

  /// Dispose active controller safely
  Future<void> _disposeController() async {
    if (_controller != null) {
      final oldController = _controller;
      _controller = null;
      await oldController?.dispose();
    }
  }

  /// Dispose camera service
  void dispose() {
    _disposeController();
    stateNotifier.dispose();
  }
}
