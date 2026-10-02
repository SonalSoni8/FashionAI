import '../entities/auth_user_entity.dart';

abstract class IAuthRepository {
  Future<AuthUserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  });

  Future<void> signOut();

  Stream<AuthUserEntity> get authStateChanges;

  AuthUserEntity get currentUser;
}
