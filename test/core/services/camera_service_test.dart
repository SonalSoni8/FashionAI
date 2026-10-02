import 'package:aura_ai/core/services/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CameraService Tests', () {
    test('Initial CameraStateData should have default values', () {
      const state = CameraStateData();
      expect(state.isInitialized, isFalse);
      expect(state.isInitializing, isFalse);
      expect(state.isRecordingVideo, isFalse);
      expect(state.isStreamingFrames, isFalse);
      expect(state.flashMode, equals(FlashMode.off));
      expect(state.currentZoom, equals(1.0));
      expect(state.selectedCameraIndex, equals(0));
    });

    test('CameraStateData copyWith modifies properties correctly', () {
      const state = CameraStateData();
      final updated = state.copyWith(
        isInitialized: true,
        isRecordingVideo: true,
        isStreamingFrames: true,
        flashMode: FlashMode.torch,
        currentZoom: 2.0,
      );

      expect(updated.isInitialized, isTrue);
      expect(updated.isRecordingVideo, isTrue);
      expect(updated.isStreamingFrames, isTrue);
      expect(updated.flashMode, equals(FlashMode.torch));
      expect(updated.currentZoom, equals(2.0));
    });

    test('cameraServiceProvider instantiates CameraService', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(cameraServiceProvider);
      expect(service, isA<CameraService>());
      expect(service.state.isInitialized, isFalse);
    });
  });
}
