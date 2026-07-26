import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/models/user_profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepository();
});

class ProfileState {
  final UserProfileEntity profile;
  final bool isLoading;
  final Failure? failure;

  const ProfileState({
    required this.profile,
    this.isLoading = false,
    this.failure,
  });

  ProfileState copyWith({
    UserProfileEntity? profile,
    bool? isLoading,
    Failure? failure,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
    );
  }
}

class ProfileControllerNotifier extends StateNotifier<ProfileState> {
  final IProfileRepository _repository;

  ProfileControllerNotifier(this._repository)
      : super(const ProfileState(profile: UserProfileEntity.empty)) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getProfile();
    result.fold(
      onSuccess: (profile) {
        state = ProfileState(profile: profile, isLoading: false);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
      },
    );
  }

  Future<void> updateProfile(UserProfileEntity updated) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.saveProfile(updated);
    result.fold(
      onSuccess: (profile) {
        state = ProfileState(profile: profile, isLoading: false);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
      },
    );
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileControllerNotifier, ProfileState>((ref) {
  return ProfileControllerNotifier(ref.watch(profileRepositoryProvider));
});
