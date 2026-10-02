import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/hive_service.dart';
import '../domain/models/garment_item_entity.dart';
import '../domain/models/wardrobe_collection_entity.dart';

class WardrobeState {
  final List<GarmentItemEntity> items;
  final String selectedCategory; // 'All', 'Outerwear', 'Tops', 'Bottoms', 'Shoes', 'Accessories'
  final String selectedCollectionId; // 'col_all', 'col_work', 'col_capsule', etc.
  final String searchQuery;
  final String? filterColorHex;
  final String? filterPattern;
  final String? filterSleeve;
  final String? filterFabric;
  final bool showFavoritesOnly;

  const WardrobeState({
    required this.items,
    this.selectedCategory = 'All',
    this.selectedCollectionId = 'col_all',
    this.searchQuery = '',
    this.filterColorHex,
    this.filterPattern,
    this.filterSleeve,
    this.filterFabric,
    this.showFavoritesOnly = false,
  });

  List<GarmentItemEntity> get filteredItems {
    return items.where((item) {
      final matchesCategory =
          selectedCategory == 'All' || item.category == selectedCategory;

      final matchesCollection = selectedCollectionId == 'col_all' ||
          item.collectionIds.contains(selectedCollectionId);

      final matchesFavorite = !showFavoritesOnly || item.isFavorite;

      final matchesSearch = searchQuery.isEmpty ||
          item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.subCategory.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.fabric.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.pattern.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesColor = filterColorHex == null ||
          item.primaryColorHex.toLowerCase() == filterColorHex!.toLowerCase();

      final matchesPattern = filterPattern == null ||
          item.pattern.toLowerCase() == filterPattern!.toLowerCase();

      final matchesSleeve = filterSleeve == null ||
          item.sleeve.toLowerCase() == filterSleeve!.toLowerCase();

      final matchesFabric = filterFabric == null ||
          item.fabric.toLowerCase().contains(filterFabric!.toLowerCase());

      return matchesCategory &&
          matchesCollection &&
          matchesFavorite &&
          matchesSearch &&
          matchesColor &&
          matchesPattern &&
          matchesSleeve &&
          matchesFabric;
    }).toList();
  }

  WardrobeState copyWith({
    List<GarmentItemEntity>? items,
    String? selectedCategory,
    String? selectedCollectionId,
    String? searchQuery,
    String? filterColorHex,
    String? filterPattern,
    String? filterSleeve,
    String? filterFabric,
    bool? showFavoritesOnly,
    bool clearFilters = false,
  }) {
    if (clearFilters) {
      return WardrobeState(
        items: items ?? this.items,
        selectedCategory: 'All',
        selectedCollectionId: 'col_all',
        searchQuery: '',
        filterColorHex: null,
        filterPattern: null,
        filterSleeve: null,
        filterFabric: null,
        showFavoritesOnly: false,
      );
    }
    return WardrobeState(
      items: items ?? this.items,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCollectionId:
          selectedCollectionId ?? this.selectedCollectionId,
      searchQuery: searchQuery ?? this.searchQuery,
      filterColorHex: filterColorHex ?? this.filterColorHex,
      filterPattern: filterPattern ?? this.filterPattern,
      filterSleeve: filterSleeve ?? this.filterSleeve,
      filterFabric: filterFabric ?? this.filterFabric,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
    );
  }
}

class WardrobeNotifier extends StateNotifier<WardrobeState> {
  WardrobeNotifier()
      : super(WardrobeState(items: _initialPresetItems())) {
    _loadFromHive();
  }

  static List<GarmentItemEntity> _initialPresetItems() {
    return [
      GarmentItemEntity(
        id: 'w1',
        name: 'Unstructured Charcoal Linen Blazer',
        category: 'Outerwear',
        subCategory: 'Linen Blazer',
        primaryColorHex: '#1E293B',
        fabric: 'Wool-Linen Blend',
        pattern: 'Solid',
        sleeve: 'Full',
        formalityScore: 8,
        seasonality: 'Spring/Summer',
        imagePath: '',
        ingestionSource: 'Camera',
        isFavorite: true,
        collectionIds: const ['col_all', 'col_work', 'col_capsule'],
        auraTwinMatchScore: '98% Match',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      GarmentItemEntity(
        id: 'w2',
        name: 'Off-White Supima Crewneck Tee',
        category: 'Tops',
        subCategory: 'Cotton Tee',
        primaryColorHex: '#F8FAFC',
        fabric: '100% Supima Cotton',
        pattern: 'Solid',
        sleeve: 'Short',
        formalityScore: 3,
        seasonality: 'All-Season',
        imagePath: '',
        ingestionSource: 'Gallery',
        isFavorite: false,
        collectionIds: const ['col_all', 'col_capsule', 'col_resort'],
        auraTwinMatchScore: '96% Match',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      GarmentItemEntity(
        id: 'w3',
        name: 'Deep Emerald Silk Satin Shirt',
        category: 'Tops',
        subCategory: 'Silk Shirt',
        primaryColorHex: '#0F766E',
        fabric: 'Mulberry Silk',
        pattern: 'Solid',
        sleeve: 'Full',
        formalityScore: 9,
        seasonality: 'Autumn/Winter',
        imagePath: '',
        ingestionSource: 'ShoppingLink',
        sourceUrl: 'https://zara.com/item/silk-shirt',
        isFavorite: true,
        collectionIds: const ['col_all', 'col_gala', 'col_work'],
        auraTwinMatchScore: '99% Match',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      GarmentItemEntity(
        id: 'w4',
        name: 'Slim Slate Tailored Trousers',
        category: 'Bottoms',
        subCategory: 'Tailored Trousers',
        primaryColorHex: '#334155',
        fabric: 'Italian Tropical Wool',
        pattern: 'Plaid',
        sleeve: 'Sleeveless',
        formalityScore: 7,
        seasonality: 'All-Season',
        imagePath: '',
        ingestionSource: 'Screenshot',
        isFavorite: true,
        collectionIds: const ['col_all', 'col_work', 'col_capsule'],
        auraTwinMatchScore: '97% Match',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      GarmentItemEntity(
        id: 'w5',
        name: 'Minimalist White Leather Low-Tops',
        category: 'Shoes',
        subCategory: 'Leather Sneakers',
        primaryColorHex: '#F1F5F9',
        fabric: 'Calfskin Leather',
        pattern: 'Solid',
        sleeve: 'Sleeveless',
        formalityScore: 4,
        seasonality: 'All-Season',
        imagePath: '',
        ingestionSource: 'AiGenerated',
        isFavorite: false,
        collectionIds: const ['col_all', 'col_resort'],
        auraTwinMatchScore: '95% Match',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _loadFromHive() {
    final raw = HiveService.getWardrobeItems;
    if (raw.isNotEmpty) {
      final loaded = raw.map((e) => GarmentItemEntity.fromJson(e)).toList();
      state = state.copyWith(items: loaded);
    }
  }

  Future<void> _persistToHive() async {
    final jsonList = state.items.map((i) => i.toJson()).toList();
    await HiveService.saveWardrobeItems(jsonList);
  }

  void setCategoryFilter(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setCollectionFilter(String collectionId) {
    state = state.copyWith(selectedCollectionId: collectionId);
  }

  void toggleFavoritesOnly() {
    state = state.copyWith(showFavoritesOnly: !state.showFavoritesOnly);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> toggleFavorite(String id) async {
    final updated = state.items.map((i) {
      if (i.id == id) {
        return i.copyWith(isFavorite: !i.isFavorite);
      }
      return i;
    }).toList();

    state = state.copyWith(items: updated);
    await _persistToHive();
  }

  Future<void> addGarment(GarmentItemEntity item) async {
    final updated = [item, ...state.items];
    state = state.copyWith(items: updated);
    await _persistToHive();
  }

  Future<void> removeGarment(String id) async {
    final updated = state.items.where((i) => i.id != id).toList();
    state = state.copyWith(items: updated);
    await _persistToHive();
  }
}

final wardrobeProvider =
    StateNotifierProvider<WardrobeNotifier, WardrobeState>((ref) {
  return WardrobeNotifier();
});
