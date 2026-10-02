import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/digital_twin_repository_impl.dart';
import '../domain/models/digital_twin_entity.dart';
import '../domain/models/image_quality_report.dart';
import '../domain/repositories/i_digital_twin_repository.dart';

final digitalTwinRepositoryProvider = Provider<IDigitalTwinRepository>((ref) {
  return DigitalTwinRepositoryImpl();
});

class DigitalTwinState {
  final DigitalTwinEntity? activeTwin;
  final String? frontImagePath;
  final String? leftSideImagePath;
  final String? rightSideImagePath;
  final ImageQualityReport? currentQualityReport;
  final bool isProcessing;
  final String? statusMessage;

  const DigitalTwinState({
    this.activeTwin,
    this.frontImagePath,
    this.leftSideImagePath,
    this.rightSideImagePath,
    this.currentQualityReport,
    this.isProcessing = false,
    this.statusMessage,
  });

  bool get hasAllAngleCaptures =>
      frontImagePath != null &&
      leftSideImagePath != null &&
      rightSideImagePath != null;

  DigitalTwinState copyWith({
    DigitalTwinEntity? activeTwin,
    String? frontImagePath,
    String? leftSideImagePath,
    String? rightSideImagePath,
    ImageQualityReport? currentQualityReport,
    bool? isProcessing,
    String? statusMessage,
  }) {
    return DigitalTwinState(
      activeTwin: activeTwin ?? this.activeTwin,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      leftSideImagePath: leftSideImagePath ?? this.leftSideImagePath,
      rightSideImagePath: rightSideImagePath ?? this.rightSideImagePath,
      currentQualityReport:
          currentQualityReport ?? this.currentQualityReport,
      isProcessing: isProcessing ?? this.isProcessing,
      statusMessage: statusMessage,
    );
  }
}

class DigitalTwinNotifier extends StateNotifier<DigitalTwinState> {
  final IDigitalTwinRepository _repository;

  DigitalTwinNotifier(this._repository) : super(const DigitalTwinState()) {
    _loadActiveTwin();
  }

  Future<void> _loadActiveTwin() async {
    final twin = await _repository.getActiveDigitalTwin('usr_obsidian_101');
    if (twin != null) {
      state = state.copyWith(activeTwin: twin);
    }
  }

  Future<void> captureFrontAngle(String path) async {
    state = state.copyWith(isProcessing: true, statusMessage: 'Validating Front Capture...');
    final quality = await _repository.validateImageQuality(path);
    state = state.copyWith(
      frontImagePath: path,
      currentQualityReport: quality,
      isProcessing: false,
      statusMessage: quality.feedbackMessage,
    );
  }

  Future<void> captureLeftAngle(String path) async {
    state = state.copyWith(isProcessing: true, statusMessage: 'Validating Left Side Profile...');
    final quality = await _repository.validateImageQuality(path);
    state = state.copyWith(
      leftSideImagePath: path,
      currentQualityReport: quality,
      isProcessing: false,
      statusMessage: quality.feedbackMessage,
    );
  }

  Future<void> captureRightAngle(String path) async {
    state = state.copyWith(isProcessing: true, statusMessage: 'Validating Right Side Profile...');
    final quality = await _repository.validateImageQuality(path);
    state = state.copyWith(
      rightSideImagePath: path,
      currentQualityReport: quality,
      isProcessing: false,
      statusMessage: quality.feedbackMessage,
    );
  }

  Future<DigitalTwinEntity?> generateAndSaveTwin(String userId) async {
    if (!state.hasAllAngleCaptures) return null;

    state = state.copyWith(
      isProcessing: true,
      statusMessage: 'Extracting 3D Pose Landmarks, Skin Tone & Body Metrics...',
    );

    final twin = await _repository.generateDigitalTwin(
      userId: userId,
      frontImagePath: state.frontImagePath!,
      leftSideImagePath: state.leftSideImagePath!,
      rightSideImagePath: state.rightSideImagePath!,
    );

    state = state.copyWith(
      activeTwin: twin,
      isProcessing: false,
      statusMessage: '✓ Permanent Mannequin Saved to Supabase & Vault',
    );

    return twin;
  }
}

final digitalTwinProvider =
    StateNotifierProvider<DigitalTwinNotifier, DigitalTwinState>((ref) {
  final repo = ref.watch(digitalTwinRepositoryProvider);
  return DigitalTwinNotifier(repo);
});
