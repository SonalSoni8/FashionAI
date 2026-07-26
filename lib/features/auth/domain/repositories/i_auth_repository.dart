import '../../../../core/errors/failure.dart';
import '../models/user_entity.dart';

abstract class IAuthRepository {
  Future<Result<UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Result<UserEntity?>> getCurrentUser();

  Future<Result<void>> logout();
}
