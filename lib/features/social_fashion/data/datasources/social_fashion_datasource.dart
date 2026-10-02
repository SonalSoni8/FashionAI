import '../domain/models/creator_profile_entity.dart';
import '../domain/models/social_post_entity.dart';

class SocialFashionDatasource {
  List<CreatorProfileEntity> getFeaturedCreators() {
    return [
      const CreatorProfileEntity(
        creatorId: 'c1',
        name: 'Hailey Bieber',
        handle: '@haileybieber',
        avatarUrl: '',
        bio: 'Streetwear x Quiet Luxury Curator',
        followerCount: 5240000,
        closetItemCount: 184,
        isVerified: true,
        isCelebrity: true,
        isFollowing: true,
      ),
      const CreatorProfileEntity(
        creatorId: 'c2',
        name: 'Timothée Chalamet',
        handle: '@tchalamet',
        avatarUrl: '',
        bio: 'Avant-Garde Red Carpet & Tailored Wool',
        followerCount: 8900000,
        closetItemCount: 142,
        isVerified: true,
        isCelebrity: true,
        isFollowing: false,
      ),
      const CreatorProfileEntity(
        creatorId: 'c3',
        name: 'Zendaya Coleman',
        handle: '@zendaya',
        avatarUrl: '',
        bio: 'High-Fashion Architectural Elegance',
        followerCount: 9600000,
        closetItemCount: 210,
        isVerified: true,
        isCelebrity: true,
        isFollowing: true,
      ),
      const CreatorProfileEntity(
        creatorId: 'c4',
        name: 'Sophia Sartorial',
        handle: '@sophiasartorial',
        avatarUrl: '',
        bio: 'Minimalist Capsule Wardrobe Architect',
        followerCount: 420000,
        closetItemCount: 68,
        isVerified: true,
        isCelebrity: false,
        isFollowing: true,
      ),
    ];
  }

  List<SocialPostEntity> getFeedPosts() {
    final creators = getFeaturedCreators();

    return [
      SocialPostEntity(
        postId: 'post_1',
        creator: creators[0], // Hailey
        lookTitle: 'Oversized Charcoal Blazer & Supima Tee',
        description:
            'Effortless Paris airport look. Paired with wide-leg slate trousers and low-profile sneakers.',
        outerwearItem: 'Unstructured Charcoal Wool Blazer',
        topItem: 'Off-White Supima Heavyweight Tee',
        bottomItem: 'Wide-Leg Slate Tailored Trousers',
        footwearItem: 'Minimalist Leather Low-Tops',
        topColorHex: '#F8FAFC',
        bottomColorHex: '#334155',
        likeCount: 14200,
        isLikedByMe: true,
        tryOnCount: 3840,
        copyCount: 1250,
        tags: const ['Quiet Luxury', 'Celebrity Closet', 'Airport Look'],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      SocialPostEntity(
        postId: 'post_2',
        creator: creators[2], // Zendaya
        lookTitle: 'Royal Emerald Silk & Sculpted Lapel Suit',
        description:
            'Met Gala afterparty look. Jewel-toned Mulberry Silk suit with brushed platinum accents.',
        outerwearItem: 'Deep Emerald Silk Satin Blazer',
        topItem: 'Mulberry Silk Corset Top',
        bottomItem: 'Sculpted Emerald High-Waist Trousers',
        footwearItem: 'Pointed Satin Pumps',
        topColorHex: '#0F766E',
        bottomColorHex: '#0F766E',
        likeCount: 28900,
        isLikedByMe: false,
        tryOnCount: 8920,
        copyCount: 3410,
        tags: const ['Red Carpet', 'Celebrity Closet', 'Jewel Tones'],
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      SocialPostEntity(
        postId: 'post_3',
        creator: creators[3], // Sophia
        lookTitle: 'Monochromatic Slate & Cashmere Knit',
        description:
            'Minimalist 4-piece capsule layout perfect for Autumn/Winter transition.',
        outerwearItem: 'Tailored Slate Overcoat',
        topItem: 'Charcoal Cashmere Crewneck',
        bottomItem: 'Slim Slate Tailored Trousers',
        footwearItem: 'Black Calfskin Loafers',
        topColorHex: '#1E293B',
        bottomColorHex: '#334155',
        likeCount: 6800,
        isLikedByMe: true,
        tryOnCount: 1420,
        copyCount: 890,
        tags: const ['Capsule Wardrobe', 'Influencer Collection', 'Workwear'],
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }
}
