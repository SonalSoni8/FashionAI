import 'package:flutter_test/flutter_test.dart';
import 'package:aura_ai/features/profile_scan/providers/user_profile_provider.dart';

void main() {
  group('UserProfileNotifier Tests', () {
    test('Initial user profile state should match defaults', () {
      final state = UserProfileState();
      expect(state.name, equals('Alex Morgan'));
      expect(state.stylePreference, equals('Quiet Luxury'));
      expect(state.isScanComplete, isFalse);
    });

    test('Updating profile modifies state correctly', () {
      final state = const UserProfileState().copyWith(
        name: 'Jordan Lee',
        stylePreference: 'Minimalist Tech',
        isScanComplete: true,
      );

      expect(state.name, equals('Jordan Lee'));
      expect(state.stylePreference, equals('Minimalist Tech'));
      expect(state.isScanComplete, isTrue);
    });
  });
}
