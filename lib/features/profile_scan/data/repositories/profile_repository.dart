import '../../../../core/errors/failure.dart';
import '../../../../core/services/hive_service.dart';
import '../../domain/models/user_profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../models/user_profile_dto.dart';

class ProfileRepository implements IProfileRepository {
  @override
  Future<Result<UserProfileEntity>> getProfile() async {
    try {
      final rawData = HiveService.userProfile;
      if (rawData == null || rawData.isEmpty) {
        return const Result.success(UserProfileEntity.empty);
      }
      final dto = UserProfileDto.fromJson(rawData);
      return Result.success(dto.toDomain());
    } catch (e) {
      return Result.failure(
        CacheFailure(message: 'Failed to read profile: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<UserProfileEntity>> saveProfile(UserProfileEntity profile) async {
    try {
      final dto = UserProfileDto.fromDomain(profile);
      await HiveService.saveUserProfile(dto.toJson());
      return Result.success(profile);
    } catch (e) {
      return Result.failure(
        CacheFailure(message: 'Failed to persist profile: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> scanFaceGeometry(String imagePath) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return Result.success({
        "faceShape": "Angular Oval",
        "symmetry": 96.5,
        "recommendedGlasses": "Geometric Acetate",
        "necklineStyle": "Spread Collar / Open Lapel",
      });
    } catch (e) {
      return Result.failure(
        ServerFailure(message: 'Face scan error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> scanSkinColorimetry(String imagePath) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return Result.success({
        "skinTone": "Warm Olive Level 3",
        "undertone": "Golden Warm",
        "seasonPalette": "Deep Autumn / Cool Winter",
        "bestColors": ["#0F766E", "#4338CA", "#1E293B", "#BE123C"],
        "worstColors": ["#D97706", "#FB7185"],
      });
    } catch (e) {
      return Result.failure(
        ServerFailure(message: 'Colorimetry scan error: ${e.toString()}'),
      );
    }
  }
}
