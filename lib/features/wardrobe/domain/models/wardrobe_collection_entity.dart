import 'package:flutter/foundation.dart';

@immutable
class WardrobeCollectionEntity {
  final String id;
  final String name;
  final String iconName;
  final String description;

  const WardrobeCollectionEntity({
    required this.id,
    required this.name,
    required this.iconName,
    required this.description,
  });

  static const List<WardrobeCollectionEntity> presets = [
    WardrobeCollectionEntity(
      id: 'col_all',
      name: 'All Items',
      iconName: 'grid',
      description: 'Complete digitized wardrobe items',
    ),
    WardrobeCollectionEntity(
      id: 'col_work',
      name: 'Workwear Staples',
      iconName: 'briefcase',
      description: 'Tailored blazers, Oxford shirts & trousers',
    ),
    WardrobeCollectionEntity(
      id: 'col_capsule',
      name: 'Capsule Wardrobe',
      iconName: 'layers',
      description: 'Essential highly versatile combinations',
    ),
    WardrobeCollectionEntity(
      id: 'col_resort',
      name: 'Summer Resort',
      iconName: 'sun',
      description: 'Breathable linen & lightweight vacation attire',
    ),
    WardrobeCollectionEntity(
      id: 'col_gala',
      name: 'Evening Black-Tie',
      iconName: 'sparkles',
      description: 'Formal silk gowns, tuxedos & luxury eveningwear',
    ),
  ];
}
