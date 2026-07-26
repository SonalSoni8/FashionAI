import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/hive_service.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? email;
  final String? userName;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.email,
    this.userName,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? email,
    String? userName,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      userName: userName ?? this.userName,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final loggedIn = HiveService.isLoggedIn;
    final email = HiveService.userEmail;
    state = state.copyWith(
      isAuthenticated: loggedIn,
      email: email,
    );
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 1000));
    await HiveService.setLoggedIn(true);
    await HiveService.setUserEmail(email);
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      email: email,
      userName: email.split('@').first,
    );
    return true;
  }

  Future<void> logout() async {
    await HiveService.setLoggedIn(false);
    state = const AuthState(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
