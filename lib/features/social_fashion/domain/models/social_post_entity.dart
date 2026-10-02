import 'package:flutter/foundation.dart';
import 'creator_profile_entity.dart';

@immutable
class SocialPostEntity {
  final String postId;
  final CreatorProfileEntity creator;
  final String lookTitle;
  final String description;
  final String topItem;
  final String bottomItem;
  final String outerwearItem;
  final String footwearItem;
  final String topColorHex;
  final String bottomColorHex;
  final int likeCount;
  final bool isLikedByMe;
  final int tryOnCount;
  final int copyCount;
  final List<String> tags;
  final DateTime createdAt;

  const SocialPostEntity({
    required this.postId,
    required this.creator,
    required this.lookTitle,
    required this.description,
    required this.topItem,
    required this.bottomItem,
    this.outerwearItem = '',
    required this.footwearItem,
    required this.topColorHex,
    required this.bottomColorHex,
    required this.likeCount,
    this.isLikedByMe = false,
    required this.tryOnCount,
    required this.copyCount,
    required this.tags,
    required this.createdAt,
  });

  SocialPostEntity copyWith({
    String? postId,
    CreatorProfileEntity? creator,
    String? lookTitle,
    String? description,
    String? topItem,
    String? bottomItem,
    String? outerwearItem,
    String? footwearItem,
    String? topColorHex,
    String? bottomColorHex,
    int? likeCount,
    bool? isLikedByMe,
    int? tryOnCount,
    int? copyCount,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return SocialPostEntity(
      postId: postId ?? this.postId,
      creator: creator ?? this.creator,
      lookTitle: lookTitle ?? this.lookTitle,
      description: description ?? this.description,
      topItem: topItem ?? this.topItem,
      bottomItem: bottomItem ?? this.bottomItem,
      outerwearItem: outerwearItem ?? this.outerwearItem,
      footwearItem: footwearItem ?? this.footwearItem,
      topColorHex: topColorHex ?? this.topColorHex,
      bottomColorHex: bottomColorHex ?? this.bottomColorHex,
      likeCount: likeCount ?? this.likeCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      tryOnCount: tryOnCount ?? this.tryOnCount,
      copyCount: copyCount ?? this.copyCount,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
