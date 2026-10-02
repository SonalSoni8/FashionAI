import 'dart:async';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../../../core/services/hive_service.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final StreamController<AuthUserEntity> _controller =
      StreamController<AuthUserEntity>.broadcast();

  AuthUserEntity _currentUser = AuthUserEntity.empty;

  AuthRepositoryImpl() {
    if (HiveService.isLoggedIn) {
      _currentUser = AuthUserEntity(
        id: 'usr_obsidian_101',
        email: HiveService.userEmail ?? 'alex.morgan@aura.ai',
        displayName: 'Alex Morgan',
        isEmailVerified: true,
      );
    }
  }

  @override
  Stream<AuthUserEntity> get authStateChanges => _controller.stream;

  @override
  AuthUserEntity get currentUser => _currentUser;

  @override
  Future<AuthUserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    _currentUser = AuthUserEntity(
      id: 'usr_obsidian_101',
      email: email,
      displayName: email.split('@').first,
      isEmailVerified: true,
    );

    await HiveService.setLoggedIn(true);
    await HiveService.setUserEmail(email);
    _controller.add(_currentUser);

    return _currentUser;
  }

  @override
  Future<AuthUserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    _currentUser = AuthUserEntity(
      id: 'usr_obsidian_101',
      email: email,
      displayName: name ?? email.split('@').first,
      isEmailVerified: true,
    );

    await HiveService.setLoggedIn(true);
    await HiveService.setUserEmail(email);
    _controller.add(_currentUser);

    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    await HiveService.setLoggedIn(false);
    _currentUser = AuthUserEntity.empty;
    _controller.add(_currentUser);
  }
}
