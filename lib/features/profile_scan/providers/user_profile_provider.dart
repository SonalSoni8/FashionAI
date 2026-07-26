import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/hive_service.dart';

class UserProfileState {
  final String name;
  final String stylePreference;
  final String faceShape;
  final String skinTone;
  final String undertone;
  final List<String> bestColors;
  final List<String> worstColors;
  final String bodyType;
  final String height;
  final bool isScanComplete;

  const UserProfileState({
    this.name = 'Alex Morgan',
    this.stylePreference = 'Quiet Luxury',
    this.faceShape = 'Oval / High Angular Symmetry',
    this.skinTone = 'Warm Olive (Level 3)',
    this.undertone = 'Golden Warm',
    this.bestColors = const ['#10B981', '#6366F1', '#06B6D4', '#1E293B'],
    this.worstColors = const ['#F59E0B', '#E11D48'],
    this.bodyType = 'Athletic V-Shape',
    this.height = "5'11\" (180 cm)",
    this.isScanComplete = false,
  });

  UserProfileState copyWith({
    String? name,
    String? stylePreference,
    String? faceShape,
    String? skinTone,
    String? undertone,
    List<String>? bestColors,
    List<String>? worstColors,
    String? bodyType,
    String? height,
    bool? isScanComplete,
  }) {
    return UserProfileState(
      name: name ?? this.name,
      stylePreference: stylePreference ?? this.stylePreference,
      faceShape: faceShape ?? this.faceShape,
      skinTone: skinTone ?? this.skinTone,
      undertone: undertone ?? this.undertone,
      bestColors: bestColors ?? this.bestColors,
      worstColors: worstColors ?? this.worstColors,
      bodyType: bodyType ?? this.bodyType,
      height: height ?? this.height,
      isScanComplete: isScanComplete ?? this.isScanComplete,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  UserProfileNotifier() : super(const UserProfileState()) {
    _loadFromHive();
  }

  void _loadFromHive() {
    final data = HiveService.userProfile;
    if (data != null && data.isNotEmpty) {
      state = state.copyWith(
        name: data['name'] ?? state.name,
        stylePreference: data['stylePreference'] ?? state.stylePreference,
        faceShape: data['faceShape'] ?? state.faceShape,
        skinTone: data['skinTone'] ?? state.skinTone,
        undertone: data['undertone'] ?? state.undertone,
        bodyType: data['bodyType'] ?? state.bodyType,
        isScanComplete: data['isScanComplete'] ?? false,
      );
    }
  }

  Future<void> updateProfile({
    String? name,
    String? stylePreference,
    String? faceShape,
    String? skinTone,
    String? undertone,
    String? bodyType,
    bool? isScanComplete,
  }) async {
    state = state.copyWith(
      name: name,
      stylePreference: stylePreference,
      faceShape: faceShape,
      skinTone: skinTone,
      undertone: undertone,
      bodyType: bodyType,
      isScanComplete: isScanComplete,
    );

    await HiveService.saveUserProfile({
      'name': state.name,
      'stylePreference': state.stylePreference,
      'faceShape': state.faceShape,
      'skinTone': state.skinTone,
      'undertone': state.undertone,
      'bodyType': state.bodyType,
      'isScanComplete': state.isScanComplete,
    });
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  return UserProfileNotifier();
});
