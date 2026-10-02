import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/aura_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/models/social_post_entity.dart';
import '../providers/social_fashion_provider.dart';

class SocialFashionView extends ConsumerStatefulWidget {
  const SocialFashionView({super.key});

  @override
  ConsumerState<SocialFashionView> createState() => _SocialFashionViewState();
}

class _SocialFashionViewState extends ConsumerState<SocialFashionView> {
  final List<String> _tabs = [
    "Discover",
    "Following",
    "Creators",
    "Celebrities",
    "Collections"
  ];

  @override
  Widget build(BuildContext context) {
    final socialState = ref.watch(socialFashionProvider);
    final posts = socialState.filteredPosts;
    final creators = socialState.creators;

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Social Fashion Network",
          style: AuraTypography.title(isDark: true),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Tabs Switcher
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final tab = _tabs[index];
                  final isSelected = tab == socialState.activeTab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          ref
                              .read(socialFashionProvider.notifier)
                              .setTab(tab);
                        }
                      },
                      selectedColor: AuraColors.auraViolet,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      labelStyle: AuraTypography.caption(isDark: true).copyWith(
                        color:
                            isSelected ? Colors.white : AuraColors.textSecondaryDark,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Verified Creator & Celebrity Spotlight Carousel
            SizedBox(
              height: 75,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: creators.length,
                itemBuilder: (context, index) {
                  final c = creators[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AuraColors.auraViolet.withOpacity(0.3),
                              child: Text(
                                c.name[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (c.isVerified)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: AuraColors.backgroundDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded,
                                    color: AuraColors.auraCyan,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.name.split(' ')[0],
                          style: AuraTypography.caption(isDark: true).copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // Post Feed List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _buildPostCard(post);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(SocialPostEntity post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(18),
        isGlowing: true,
        glowColor: AuraColors.auraViolet,
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Creator Header Bar
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AuraColors.auraViolet.withOpacity(0.4),
                  child: Text(
                    post.creator.name[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.creator.name,
                            style: AuraTypography.title(isDark: true).copyWith(fontSize: 14),
                          ),
                          if (post.creator.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified_rounded,
                              color: AuraColors.auraCyan,
                              size: 14,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        "${post.creator.handle} · ${post.creator.bio}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AuraTypography.caption(isDark: true),
                      ),
                    ],
                  ),
                ),
                // Follow Button Toggle
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    side: BorderSide(
                      color: post.creator.isFollowing
                          ? AuraColors.glassBorderDark
                          : AuraColors.auraViolet,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ref.read(socialFashionProvider.notifier).toggleFollow(post.creator.creatorId);
                  },
                  child: Text(
                    post.creator.isFollowing ? "Following" : "Follow",
                    style: AuraTypography.caption(isDark: true).copyWith(
                      color: post.creator.isFollowing ? Colors.white70 : AuraColors.auraViolet,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Look Title & Description
            Text(
              post.lookTitle,
              style: AuraTypography.headingMedium(isDark: true).copyWith(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              post.description,
              style: AuraTypography.bodyMedium(isDark: true),
            ),
            const SizedBox(height: 12),

            // Outfits Breakdown Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white.withOpacity(0.04),
                border: Border.all(color: AuraColors.glassBorderDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  if (post.outerwearItem.isNotEmpty) _buildItemRow("Outerwear", post.outerwearItem),
                  _buildItemRow("Top", post.topItem),
                  _buildItemRow("Bottom", post.bottomItem),
                  _buildItemRow("Footwear", post.footwearItem),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Social Action Buttons Bar (Like, Copy, Try on Aura Twin)
            Row(
              children: [
                // Heart Like Toggle
                IconButton(
                  icon: Icon(
                    post.isLikedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: post.isLikedByMe ? AuraColors.auraRose : Colors.white70,
                    size: 22,
                  ),
                  onPressed: () {
                    ref.read(socialFashionProvider.notifier).toggleLike(post.postId);
                  },
                ),
                Text(
                  "${post.likeCount}",
                  style: AuraTypography.caption(isDark: true).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),

                // Copy Outfit
                GestureDetector(
                  onTap: () {
                    ref.read(socialFashionProvider.notifier).copyOutfitToCloset(post);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Outfit recipe copied to your Digital Closet!"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.content_copy_rounded, color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "Copy (${post.copyCount})",
                        style: AuraTypography.caption(isDark: true),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Try on My Aura Twin Action Button
                AuraButton(
                  text: "Try on Aura Twin",
                  icon: Icons.accessibility_new_rounded,
                  height: 38,
                  style: AuraButtonStyle.primary,
                  onPressed: () {
                    ref.read(socialFashionProvider.notifier).tryOnFriendOutfit(post);
                    context.push(AppRoutes.virtualTryOn);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: AuraTypography.caption(isDark: true).copyWith(
              color: AuraColors.textMutedDark,
              fontSize: 11,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AuraTypography.caption(isDark: true).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
