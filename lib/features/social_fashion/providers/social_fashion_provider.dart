import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../virtual_tryon/providers/virtual_tryon_provider.dart';
import '../../virtual_tryon/domain/models/tryon_layer_item.dart';
import '../../wardrobe/domain/models/garment_item_entity.dart';
import '../../wardrobe/providers/wardrobe_provider.dart';
import '../data/datasources/social_fashion_datasource.dart';
import '../domain/models/creator_profile_entity.dart';
import '../domain/models/social_post_entity.dart';

class SocialFashionState {
  final List<SocialPostEntity> posts;
  final List<CreatorProfileEntity> creators;
  final String activeTab; // 'Discover', 'Following', 'Creators', 'Celebrities', 'Collections'

  const SocialFashionState({
    required this.posts,
    required this.creators,
    this.activeTab = 'Discover',
  });

  List<SocialPostEntity> get filteredPosts {
    if (activeTab == 'Following') {
      return posts.where((p) => p.creator.isFollowing).toList();
    } else if (activeTab == 'Celebrities') {
      return posts.where((p) => p.creator.isCelebrity).toList();
    } else if (activeTab == 'Creators') {
      return posts.where((p) => !p.creator.isCelebrity).toList();
    }
    return posts;
  }

  SocialFashionState copyWith({
    List<SocialPostEntity>? posts,
    List<CreatorProfileEntity>? creators,
    String? activeTab,
  }) {
    return SocialFashionState(
      posts: posts ?? this.posts,
      creators: creators ?? this.creators,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}

class SocialFashionNotifier extends StateNotifier<SocialFashionState> {
  final Ref _ref;
  final SocialFashionDatasource _datasource = SocialFashionDatasource();

  SocialFashionNotifier(this._ref)
      : super(
          SocialFashionState(
            posts: SocialFashionDatasource().getFeedPosts(),
            creators: SocialFashionDatasource().getFeaturedCreators(),
          ),
        );

  void setTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }

  void toggleLike(String postId) {
    final updatedPosts = state.posts.map((p) {
      if (p.postId == postId) {
        final newIsLiked = !p.isLikedByMe;
        return p.copyWith(
          isLikedByMe: newIsLiked,
          likeCount: newIsLiked ? p.likeCount + 1 : p.likeCount - 1,
        );
      }
      return p;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  void toggleFollow(String creatorId) {
    final updatedCreators = state.creators.map((c) {
      if (c.creatorId == creatorId) {
        return c.copyWith(isFollowing: !c.isFollowing);
      }
      return c;
    }).toList();

    state = state.copyWith(creators: updatedCreators);
  }

  Future<void> copyOutfitToCloset(SocialPostEntity post) async {
    final newItem = GarmentItemEntity(
      id: 'copy_${DateTime.now().millisecondsSinceEpoch}',
      name: post.lookTitle,
      category: 'Tops',
      subCategory: post.topItem,
      primaryColorHex: post.topColorHex,
      fabric: 'Mulberry Silk Blend',
      pattern: 'Solid',
      sleeve: 'Full',
      formalityScore: 8,
      seasonality: 'All-Season',
      imagePath: '',
      ingestionSource: 'Gallery',
      isFavorite: true,
      collectionIds: const ['col_all', 'col_capsule'],
      auraTwinMatchScore: '99% Match',
      createdAt: DateTime.now(),
    );

    await _ref.read(wardrobeProvider.notifier).addGarment(newItem);

    final updatedPosts = state.posts.map((p) {
      if (p.postId == post.postId) {
        return p.copyWith(copyCount: p.copyCount + 1);
      }
      return p;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  void tryOnFriendOutfit(SocialPostEntity post) {
    // Equip friend's top item onto user's Aura Twin
    _ref.read(virtualTryOnProvider.notifier).wearGarment(
          garmentId: post.postId,
          name: post.topItem,
          category: TryOnLayerCategory.top,
          colorHex: post.topColorHex,
          zIndex: 3,
        );

    // Equip bottom item
    _ref.read(virtualTryOnProvider.notifier).wearGarment(
          garmentId: '${post.postId}_bot',
          name: post.bottomItem,
          category: TryOnLayerCategory.bottom,
          colorHex: post.bottomColorHex,
          zIndex: 2,
        );

    final updatedPosts = state.posts.map((p) {
      if (p.postId == post.postId) {
        return p.copyWith(tryOnCount: p.tryOnCount + 1);
      }
      return p;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }
}

final socialFashionProvider =
    StateNotifierProvider<SocialFashionNotifier, SocialFashionState>((ref) {
  return SocialFashionNotifier(ref);
});
