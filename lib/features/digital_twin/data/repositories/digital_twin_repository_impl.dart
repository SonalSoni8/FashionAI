import '../../../../core/services/hive_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/models/digital_twin_entity.dart';
import '../../domain/models/image_quality_report.dart';
import '../../domain/repositories/i_digital_twin_repository.dart';
import '../datasources/vision_detection_service.dart';

class DigitalTwinRepositoryImpl implements IDigitalTwinRepository {
  final VisionDetectionService _visionService = VisionDetectionService();

  @override
  Future<ImageQualityReport> validateImageQuality(String imagePath) async {
    return await _visionService.validateCaptureQuality(imagePath);
  }

  @override
  Future<DigitalTwinEntity> generateDigitalTwin({
    required String userId,
    required String frontImagePath,
    required String leftSideImagePath,
    required String rightSideImagePath,
  }) async {
    final twin = await _visionService.extractAttributesAndGenerateTwin(
      userId: userId,
      frontImagePath: frontImagePath,
      leftSideImagePath: leftSideImagePath,
      rightSideImagePath: rightSideImagePath,
    );

    await saveDigitalTwinToSupabase(twin);
    return twin;
  }

  @override
  Future<void> saveDigitalTwinToSupabase(DigitalTwinEntity twin) async {
    // Save to Hive local profile box
    await HiveService.saveUserProfile(twin.toJson());

    // Sync to Supabase digital_twins database table if client available
    try {
      final client = SupabaseService.client;
      if (client != null) {
        await client.from('digital_twins').upsert(twin.toJson());
      }
    } catch (_) {
      // Offline fallback handling
    }
  }

  @override
  Future<DigitalTwinEntity?> getActiveDigitalTwin(String userId) async {
    final data = HiveService.userProfile;
    if (data != null && data.containsKey('twin_id')) {
      return DigitalTwinEntity.fromJson(data);
    }
    return null;
  }
}
