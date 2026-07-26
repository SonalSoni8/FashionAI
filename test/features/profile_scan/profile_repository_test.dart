import 'package:flutter_test/flutter_test.dart';
import 'package:aura_ai/features/profile_scan/data/repositories/profile_repository.dart';
import 'package:aura_ai/features/profile_scan/domain/models/user_profile_entity.dart';

void main() {
  late ProfileRepository repository;

  setUp(() {
    repository = ProfileRepository();
  });

  group('ProfileRepository Enterprise Unit Tests', () {
    test('getProfile returns Result.success with default or saved profile', () async {
      final result = await repository.getProfile();
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isNotNull);
      expect(result.dataOrNull!.name, isNotEmpty);
    });

    test('scanFaceGeometry returns structured face analysis data', () async {
      final result = await repository.scanFaceGeometry('mock_image_path');
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull!['faceShape'], equals('Angular Oval'));
    });
  });
}
