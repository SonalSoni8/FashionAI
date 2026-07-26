import '../../../../core/errors/failure.dart';
import '../../../../core/services/hive_service.dart';
import '../../domain/models/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  @override
  Future<Result<UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      if (email.contains('error')) {
        return const Result.failure(
          AuthFailure(message: 'Invalid credentials provided.'),
        );
      }

      final user = UserEntity(
        id: 'usr_883921',
        email: email,
        name: email.split('@').first,
        isProfileComplete: HiveService.userProfile != null &&
            (HiveService.userProfile!['isScanComplete'] ?? false),
      );

      await HiveService.setLoggedIn(true);
      await HiveService.setUserEmail(email);

      return Result.success(user);
    } catch (e) {
      return Result.failure(
        AuthFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final user = UserEntity(
        id: 'usr_991204',
        email: email,
        name: name,
        isProfileComplete: false,
      );

      await HiveService.setLoggedIn(true);
      await HiveService.setUserEmail(email);

      return Result.success(user);
    } catch (e) {
      return Result.failure(
        AuthFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final isLoggedIn = HiveService.isLoggedIn;
      if (!isLoggedIn) return const Result.success(null);

      final email = HiveService.userEmail ?? 'alex.fashion@aura.ai';
      final user = UserEntity(
        id: 'usr_883921',
        email: email,
        name: email.split('@').first,
        isProfileComplete: HiveService.userProfile != null &&
            (HiveService.userProfile!['isScanComplete'] ?? false),
      );
      return Result.success(user);
    } catch (e) {
      return Result.failure(
        CacheFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await HiveService.setLoggedIn(false);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        CacheFailure(message: e.toString()),
      );
    }
  }
}
