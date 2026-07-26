import 'package:flutter_test/flutter_test.dart';
import 'package:aura_ai/features/auth/data/repositories/auth_repository.dart';

void main() {
  late AuthRepository repository;

  setUp(() {
    repository = AuthRepository();
  });

  group('AuthRepository Enterprise Unit Tests', () {
    test('loginWithEmail returns Result.success on valid credentials', () async {
      final result = await repository.loginWithEmail(
        email: 'alex.fashion@aura.ai',
        password: 'password123',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isNotNull);
      expect(result.dataOrNull!.email, equals('alex.fashion@aura.ai'));
    });

    test('loginWithEmail returns Result.failure on error credentials', () async {
      final result = await repository.loginWithEmail(
        email: 'error.user@aura.ai',
        password: 'password123',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isNotNull);
      expect(result.failureOrNull!.message, contains('Invalid credentials'));
    });
  });
}
