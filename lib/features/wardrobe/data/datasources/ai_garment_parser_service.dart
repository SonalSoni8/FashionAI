import 'package:uuid/uuid.dart';

import '../../domain/models/garment_item_entity.dart';

class AiGarmentParserService {
  Future<GarmentItemEntity> parsePhotoOrScreenshot({
    required String imagePath,
    required String source, // 'Camera', 'Gallery', 'Screenshot'
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return GarmentItemEntity(
      id: const Uuid().v4(),
      name: 'Digitized Minimalist Garment',
      category: 'Outerwear',
      subCategory: 'Blazer',
      primaryColorHex: '#1E293B',
      secondaryColorHex: '#0F172A',
      fabric: 'Wool Blend',
      pattern: 'Solid',
      sleeve: 'Full',
      formalityScore: 8,
      seasonality: 'Autumn/Winter',
      imagePath: imagePath,
      transparentImageUrl: imagePath,
      ingestionSource: source,
      auraTwinMatchScore: '98% Match',
      createdAt: DateTime.now(),
    );
  }

  Future<GarmentItemEntity> parseShoppingLink(String url) async {
    await Future.delayed(const Duration(seconds: 1));

    String name = 'Designer Italian Silk Shirt';
    String category = 'Tops';
    String fabric = 'Mulberry Silk';
    String hex = '#0F766E';

    if (url.contains('zara') || url.contains('blazer')) {
      name = 'Oversized Double-Breasted Tailored Blazer';
      category = 'Outerwear';
      fabric = 'Structured Wool';
      hex = '#1E293B';
    } else if (url.contains('denim') || url.contains('jeans')) {
      name = 'Japanese Selvedge Indigo Denim Jeans';
      category = 'Bottoms';
      fabric = 'Raw Denim';
      hex = '#1E3A8A';
    }

    return GarmentItemEntity(
      id: const Uuid().v4(),
      name: name,
      category: category,
      subCategory: 'Parser Item',
      primaryColorHex: hex,
      fabric: fabric,
      pattern: 'Solid',
      sleeve: 'Full',
      formalityScore: 7,
      seasonality: 'All-Season',
      imagePath: '',
      transparentImageUrl: '',
      sourceUrl: url,
      ingestionSource: 'ShoppingLink',
      auraTwinMatchScore: '99% Match',
      createdAt: DateTime.now(),
    );
  }

  Future<GarmentItemEntity> generateAiGarment(String prompt) async {
    await Future.delayed(const Duration(seconds: 2));

    return GarmentItemEntity(
      id: const Uuid().v4(),
      name: prompt.isEmpty ? 'AI Generated Avant-Garde Coat' : prompt,
      category: 'Outerwear',
      subCategory: 'AI Custom',
      primaryColorHex: '#6366F1',
      secondaryColorHex: '#EC4899',
      fabric: 'Cyber-Luxe Cashmere',
      pattern: 'Houndstooth',
      sleeve: 'Full',
      formalityScore: 9,
      seasonality: 'All-Season',
      imagePath: '',
      transparentImageUrl: '',
      ingestionSource: 'AiGenerated',
      auraTwinMatchScore: '100% Match',
      createdAt: DateTime.now(),
    );
  }
}
