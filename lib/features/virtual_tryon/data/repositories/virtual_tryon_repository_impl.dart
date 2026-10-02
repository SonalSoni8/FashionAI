import '../../digital_twin/domain/models/pose_landmark_point.dart';
import '../../domain/models/tryon_layer_item.dart';
import '../../domain/models/tryon_render_result.dart';
import '../../domain/repositories/i_virtual_tryon_repository.dart';
import '../datasources/cloud_diffusion_tryon_service.dart';
import '../datasources/landmark_warping_renderer.dart';

class VirtualTryOnRepositoryImpl implements IVirtualTryOnRepository {
  final LandmarkWarpingRenderer _localRenderer = LandmarkWarpingRenderer();
  final CloudDiffusionTryOnService _cloudService = CloudDiffusionTryOnService();

  @override
  Future<TryOnRenderResult> renderTryOnSession({
    required String twinId,
    required List<TryOnLayerItem> activeLayers,
    required List<PoseLandmarkPoint> poseLandmarks,
    required RenderEngineMode engineMode,
  }) async {
    if (engineMode == RenderEngineMode.cloudDiffusion) {
      return await _cloudService.renderCloudDiffusionPass(
        twinId: twinId,
        activeLayers: activeLayers,
      );
    }

    return await _localRenderer.renderLocalVectorMesh(
      twinId: twinId,
      activeLayers: activeLayers,
    );
  }
}
