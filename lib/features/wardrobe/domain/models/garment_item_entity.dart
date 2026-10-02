import 'package:flutter/foundation.dart';

@immutable
class GarmentItemEntity {
  final String id;
  final String name;
  final String category; // Outerwear, Tops, Bottoms, Shoes, Accessories, One-Piece
  final String subCategory; // Blazer, Supima Tee, Silk Shirt, Chinos, Sneakers
  final String primaryColorHex;
  final String secondaryColorHex;
  final String fabric; // Cotton, Silk, Denim, Wool, Linen, Leather
  final String pattern; // Solid, Striped, Plaid, Floral, Houndstooth, Graphic
  final String sleeve; // Full, Short, Sleeveless, 3/4
  final int formalityScore; // 1 (Ultra Casual) to 10 (Black Tie)
  final String seasonality; // Spring/Summer, Autumn/Winter, All-Season
  final String imagePath;
  final String transparentImageUrl;
  final String sourceUrl;
  final String ingestionSource; // Camera, Gallery, Screenshot, ShoppingLink, AiGenerated
  final bool isFavorite;
  final List<String> collectionIds;
  final String auraTwinMatchScore; // e.g. "98% Match"
  final DateTime createdAt;

  const GarmentItemEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.primaryColorHex,
    this.secondaryColorHex = '#000000',
    required this.fabric,
    this.pattern = 'Solid',
    this.sleeve = 'Short',
    required this.formalityScore,
    required this.seasonality,
    required this.imagePath,
    this.transparentImageUrl = '',
    this.sourceUrl = '',
    this.ingestionSource = 'Camera',
    this.isFavorite = false,
    this.collectionIds = const ['col_all'],
    required this.auraTwinMatchScore,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'primaryColorHex': primaryColorHex,
      'secondaryColorHex': secondaryColorHex,
      'fabric': fabric,
      'pattern': pattern,
      'sleeve': sleeve,
      'formalityScore': formalityScore,
      'seasonality': seasonality,
      'imagePath': imagePath,
      'transparentImageUrl': transparentImageUrl,
      'sourceUrl': sourceUrl,
      'ingestionSource': ingestionSource,
      'isFavorite': isFavorite,
      'collectionIds': collectionIds,
      'auraTwinMatchScore': auraTwinMatchScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GarmentItemEntity.fromJson(Map<String, dynamic> json) {
    return GarmentItemEntity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Tops',
      subCategory: json['subCategory'] ?? '',
      primaryColorHex: json['primaryColorHex'] ?? '#1E293B',
      secondaryColorHex: json['secondaryColorHex'] ?? '#000000',
      fabric: json['fabric'] ?? 'Cotton',
      pattern: json['pattern'] ?? 'Solid',
      sleeve: json['sleeve'] ?? 'Short',
      formalityScore: json['formalityScore'] ?? 5,
      seasonality: json['seasonality'] ?? 'All-Season',
      imagePath: json['imagePath'] ?? '',
      transparentImageUrl: json['transparentImageUrl'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
      ingestionSource: json['ingestionSource'] ?? 'Camera',
      isFavorite: json['isFavorite'] ?? false,
      collectionIds: (json['collectionIds'] as List? ?? ['col_all'])
          .map((e) => e.toString())
          .toList(),
      auraTwinMatchScore: json['auraTwinMatchScore'] ?? '95% Match',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  GarmentItemEntity copyWith({
    String? id,
    String? name,
    String? category,
    String? subCategory,
    String? primaryColorHex,
    String? secondaryColorHex,
    String? fabric,
    String? pattern,
    String? sleeve,
    int? formalityScore,
    String? seasonality,
    String? imagePath,
    String? transparentImageUrl,
    String? sourceUrl,
    String? ingestionSource,
    bool? isFavorite,
    List<String>? collectionIds,
    String? auraTwinMatchScore,
    DateTime? createdAt,
  }) {
    return GarmentItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      secondaryColorHex: secondaryColorHex ?? this.secondaryColorHex,
      fabric: fabric ?? this.fabric,
      pattern: pattern ?? this.pattern,
      sleeve: sleeve ?? this.sleeve,
      formalityScore: formalityScore ?? this.formalityScore,
      seasonality: seasonality ?? this.seasonality,
      imagePath: imagePath ?? this.imagePath,
      transparentImageUrl:
          transparentImageUrl ?? this.transparentImageUrl,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      ingestionSource: ingestionSource ?? this.ingestionSource,
      isFavorite: isFavorite ?? this.isFavorite,
      collectionIds: collectionIds ?? this.collectionIds,
      auraTwinMatchScore: auraTwinMatchScore ?? this.auraTwinMatchScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
