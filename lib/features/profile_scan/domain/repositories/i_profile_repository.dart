import '../../../../core/errors/failure.dart';
import '../models/user_profile_entity.dart';

abstract class IProfileRepository {
  Future<Result<UserProfileEntity>> getProfile();

  Future<Result<UserProfileEntity>> saveProfile(UserProfileEntity profile);

  Future<Result<Map<String, dynamic>>> scanFaceGeometry(String imagePath);

  Future<Result<Map<String, dynamic>>> scanSkinColorimetry(String imagePath);
}
