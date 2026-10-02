import '../../digital_twin/domain/models/pose_landmark_point.dart';
import '../models/tryon_layer_item.dart';
import '../models/tryon_render_result.dart';

abstract class IVirtualTryOnRepository {
  Future<TryOnRenderResult> renderTryOnSession({
    required String twinId,
    required List<TryOnLayerItem> activeLayers,
    required List<PoseLandmarkPoint> poseLandmarks,
    required RenderEngineMode engineMode,
  });
}
