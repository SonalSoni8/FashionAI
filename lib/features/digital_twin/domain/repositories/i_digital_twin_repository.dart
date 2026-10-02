import '../models/digital_twin_entity.dart';
import '../models/image_quality_report.dart';

abstract class IDigitalTwinRepository {
  Future<ImageQualityReport> validateImageQuality(String imagePath);

  Future<DigitalTwinEntity> generateDigitalTwin({
    required String userId,
    required String frontImagePath,
    required String leftSideImagePath,
    required String rightSideImagePath,
  });

  Future<void> saveDigitalTwinToSupabase(DigitalTwinEntity twin);

  Future<DigitalTwinEntity?> getActiveDigitalTwin(String userId);
}
