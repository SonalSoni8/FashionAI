import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/models/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
});

class AuthSessionState {
  final UserEntity? user;
  final bool isLoading;
  final Failure? failure;

  const AuthSessionState({
    this.user,
    this.isLoading = false,
    this.failure,
  });

  bool get isAuthenticated => user != null;

  AuthSessionState copyWith({
    UserEntity? user,
    bool? isLoading,
    Failure? failure,
  }) {
    return AuthSessionState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
    );
  }
}

class AuthControllerNotifier extends StateNotifier<AuthSessionState> {
  final IAuthRepository _repository;

  AuthControllerNotifier(this._repository) : super(const AuthSessionState()) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getCurrentUser();
    result.fold(
      onSuccess: (user) {
        state = AuthSessionState(user: user, isLoading: false);
      },
      onFailure: (failure) {
        state = AuthSessionState(failure: failure, isLoading: false);
      },
    );
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _repository.loginWithEmail(
      email: email,
      password: password,
    );

    return result.fold(
      onSuccess: (user) {
        state = AuthSessionState(user: user, isLoading: false);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthSessionState();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, AuthSessionState>((ref) {
  return AuthControllerNotifier(ref.watch(authRepositoryProvider));
});
