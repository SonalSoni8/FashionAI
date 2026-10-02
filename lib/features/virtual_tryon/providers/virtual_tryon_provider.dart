import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../digital_twin/providers/digital_twin_provider.dart';
import '../data/repositories/virtual_tryon_repository_impl.dart';
import '../domain/models/tryon_layer_item.dart';
import '../domain/models/tryon_render_result.dart';
import '../domain/repositories/i_virtual_tryon_repository.dart';
import '../domain/usecases/compute_landmark_transform_usecase.dart';

final virtualTryOnRepositoryProvider = Provider<IVirtualTryOnRepository>((ref) {
  return VirtualTryOnRepositoryImpl();
});

class VirtualTryOnState {
  final Map<TryOnLayerCategory, TryOnLayerItem> activeLayers;
  final RenderEngineMode selectedEngineMode;
  final TryOnRenderResult? lastRenderResult;
  final bool isRendering;
  final bool showPoseMesh;

  const VirtualTryOnState({
    this.activeLayers = const {},
    this.selectedEngineMode = RenderEngineMode.landmarkMesh,
    this.lastRenderResult,
    this.isRendering = false,
    this.showPoseMesh = true,
  });

  List<TryOnLayerItem> get sortedLayers {
    final list = activeLayers.values.toList();
    list.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    return list;
  }

  VirtualTryOnState copyWith({
    Map<TryOnLayerCategory, TryOnLayerItem>? activeLayers,
    RenderEngineMode? selectedEngineMode,
    TryOnRenderResult? lastRenderResult,
    bool? isRendering,
    bool? showPoseMesh,
  }) {
    return VirtualTryOnState(
      activeLayers: activeLayers ?? this.activeLayers,
      selectedEngineMode: selectedEngineMode ?? this.selectedEngineMode,
      lastRenderResult: lastRenderResult ?? this.lastRenderResult,
      isRendering: isRendering ?? this.isRendering,
      showPoseMesh: showPoseMesh ?? this.showPoseMesh,
    );
  }
}

class VirtualTryOnNotifier extends StateNotifier<VirtualTryOnState> {
  final IVirtualTryOnRepository _repository;
  final ComputeLandmarkTransformUseCase _transformUseCase =
      ComputeLandmarkTransformUseCase();
  final Ref _ref;

  VirtualTryOnNotifier(this._repository, this._ref)
      : super(const VirtualTryOnState()) {
    _equipDefaultPresets();
  }

  void _equipDefaultPresets() {
    wearGarment(
      garmentId: 'w2',
      name: 'Off-White Supima Tee',
      category: TryOnLayerCategory.top,
      colorHex: '#F8FAFC',
      zIndex: 3,
    );
    wearGarment(
      garmentId: 'w4',
      name: 'Slim Slate Tailored Trousers',
      category: TryOnLayerCategory.bottom,
      colorHex: '#334155',
      zIndex: 2,
    );
    wearGarment(
      garmentId: 'w5',
      name: 'Minimalist Leather Low-Tops',
      category: TryOnLayerCategory.footwear,
      colorHex: '#F1F5F9',
      zIndex: 1,
    );
  }

  void wearGarment({
    required String garmentId,
    required String name,
    required TryOnLayerCategory category,
    required String colorHex,
    required int zIndex,
  }) {
    final rawLayer = TryOnLayerItem(
      garmentId: garmentId,
      name: name,
      category: category,
      primaryColorHex: colorHex,
      zIndex: zIndex,
    );

    final twinState = _ref.read(digitalTwinProvider);
    final landmarks = twinState.activeTwin?.poseLandmarks ?? [];

    final computedLayer = _transformUseCase.computeLayerTransform(
      layer: rawLayer,
      poseLandmarks: landmarks,
    );

    final updatedMap =
        Map<TryOnLayerCategory, TryOnLayerItem>.from(state.activeLayers);
    updatedMap[category] = computedLayer;

    state = state.copyWith(activeLayers: updatedMap);
    _triggerRender();
  }

  void removeLayer(TryOnLayerCategory category) {
    final updatedMap =
        Map<TryOnLayerCategory, TryOnLayerItem>.from(state.activeLayers);
    updatedMap.remove(category);
    state = state.copyWith(activeLayers: updatedMap);
    _triggerRender();
  }

  void setEngineMode(RenderEngineMode mode) {
    state = state.copyWith(selectedEngineMode: mode);
    _triggerRender();
  }

  void togglePoseMesh() {
    state = state.copyWith(showPoseMesh: !state.showPoseMesh);
  }

  Future<void> _triggerRender() async {
    state = state.copyWith(isRendering: true);

    final twinState = _ref.read(digitalTwinProvider);
    final twinId = twinState.activeTwin?.twinId ?? 'TWIN_DEFAULT';
    final landmarks = twinState.activeTwin?.poseLandmarks ?? [];

    final result = await _repository.renderTryOnSession(
      twinId: twinId,
      activeLayers: state.sortedLayers,
      poseLandmarks: landmarks,
      engineMode: state.selectedEngineMode,
    );

    state = state.copyWith(
      lastRenderResult: result,
      isRendering: false,
    );
  }
}

final virtualTryOnProvider =
    StateNotifierProvider<VirtualTryOnNotifier, VirtualTryOnState>((ref) {
  final repo = ref.watch(virtualTryOnRepositoryProvider);
  return VirtualTryOnNotifier(repo, ref);
});
