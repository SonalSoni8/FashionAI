import 'package:flutter/foundation.dart';

@immutable
class CreatorProfileEntity {
  final String creatorId;
  final String name;
  final String handle;
  final String avatarUrl;
  final String bio;
  final int followerCount;
  final int closetItemCount;
  final bool isVerified;
  final bool isCelebrity;
  final bool isFollowing;

  const CreatorProfileEntity({
    required this.creatorId,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.bio,
    required this.followerCount,
    required this.closetItemCount,
    this.isVerified = true,
    this.isCelebrity = false,
    this.isFollowing = false,
  });

  CreatorProfileEntity copyWith({
    String? creatorId,
    String? name,
    String? handle,
    String? avatarUrl,
    String? bio,
    int? followerCount,
    int? closetItemCount,
    bool? isVerified,
    bool? isCelebrity,
    bool? isFollowing,
  }) {
    return CreatorProfileEntity(
      creatorId: creatorId ?? this.creatorId,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followerCount: followerCount ?? this.followerCount,
      closetItemCount: closetItemCount ?? this.closetItemCount,
      isVerified: isVerified ?? this.isVerified,
      isCelebrity: isCelebrity ?? this.isCelebrity,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
