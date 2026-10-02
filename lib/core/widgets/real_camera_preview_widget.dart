import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/camera_service.dart';
import '../theme/aura_colors.dart';
import '../theme/aura_typography.dart';
import 'morphing_button.dart';

class RealCameraPreviewWidget extends ConsumerStatefulWidget {
  final Function(String imagePath) onPictureTaken;
  final CameraLensDirection initialDirection;

  const RealCameraPreviewWidget({
    super.key,
    required this.onPictureTaken,
    this.initialDirection = CameraLensDirection.back,
  });

  @override
  ConsumerState<RealCameraPreviewWidget> createState() =>
      _RealCameraPreviewWidgetState();
}

class _RealCameraPreviewWidgetState
    extends ConsumerState<RealCameraPreviewWidget>
    with WidgetsBindingObserver {
  late CameraService _cameraService;
  String? _capturedImagePath;
  double _baseScale = 1.0;
  Offset? _focusTapPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraService = ref.read(cameraServiceProvider);
    _cameraService.initialize(preferredDirection: widget.initialDirection);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _cameraService.handleAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _handleCapture() async {
    final file = await _cameraService.takePicture();
    if (file != null && mounted) {
      setState(() => _capturedImagePath = file.path);
      widget.onPictureTaken(file.path);
    }
  }

  void _handleFocusTap(TapUpDetails details, BoxConstraints constraints) {
    final Offset tapPosition = details.localPosition;
    final double dx = tapPosition.dx / constraints.maxWidth;
    final double dy = tapPosition.dy / constraints.maxHeight;

    _cameraService.setFocusPoint(Offset(dx, dy));

    setState(() {
      _focusTapPosition = tapPosition;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _focusTapPosition = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CameraStateData>(
      valueListenable: _cameraService.stateNotifier,
      builder: (context, cameraState, child) {
        // Render captured photo preview if available
        if (_capturedImagePath != null) {
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: kIsWeb
                    ? Image.network(
                        _capturedImagePath!,
                        height: 380,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_capturedImagePath!),
                        height: 380,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MorphingButton(
                      text: "Retake Photo",
                      icon: Icons.refresh_rounded,
                      style: MorphingButtonStyle.glassOutline,
                      onPressed: () {
                        setState(() => _capturedImagePath = null);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        // Render error or initialization fallback
        if (cameraState.isInitializing ||
            !cameraState.isInitialized ||
            _cameraService.controller == null) {
          return Container(
            height: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AuraColors.surfaceDarkElevated,
              border: Border.all(color: AuraColors.glassBorderDark),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cameraState.errorMessage != null) ...[
                    const Icon(
                      Icons.no_photography_rounded,
                      color: AuraColors.auraRose,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        cameraState.errorMessage!,
                        textAlign: TextAlign.center,
                        style: AuraTypography.bodyMedium(isDark: true),
                      ),
                    ),
                    const SizedBox(height: 16),
                    MorphingButton(
                      text: "Grant Camera Permission",
                      icon: Icons.security_rounded,
                      style: MorphingButtonStyle.glassOutline,
                      onPressed: () => _cameraService.initialize(
                        preferredDirection: widget.initialDirection,
                      ),
                    ),
                  ] else ...[
                    const CircularProgressIndicator(color: AuraColors.auraViolet),
                    const SizedBox(height: 16),
                    Text(
                      "Initializing Hardware Camera...",
                      style: AuraTypography.bodyMedium(isDark: true),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        final controller = _cameraService.controller!;

        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onScaleStart: (details) {
                    _baseScale = cameraState.currentZoom;
                  },
                  onScaleUpdate: (details) {
                    final newZoom = _baseScale * details.scale;
                    _cameraService.setZoomLevel(newZoom);
                  },
                  onTapUp: (details) => _handleFocusTap(details, constraints),
                  child: Stack(
                    children: [
                      // Camera Live Preview
                      CameraPreview(controller),

                      // Focus point ring indicator
                      if (_focusTapPosition != null)
                        Positioned(
                          left: _focusTapPosition!.dx - 24,
                          top: _focusTapPosition!.dy - 24,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AuraColors.auraCyan,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                      // Top Flash & Flip Camera Control Overlay
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black45,
                                ),
                                child: Icon(
                                  cameraState.flashMode == FlashMode.torch
                                      ? Icons.flash_on_rounded
                                      : Icons.flash_off_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              onPressed: () => _cameraService.toggleFlash(),
                            ),
                            if (cameraState.maxZoom > cameraState.minZoom)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.black45,
                                ),
                                child: Text(
                                  "${cameraState.currentZoom.toStringAsFixed(1)}x",
                                  style: AuraTypography.caption(isDark: true)
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            if (cameraState.availableCameras.length > 1)
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black45,
                                  ),
                                  child: const Icon(
                                    Icons.cameraswitch_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                onPressed: () => _cameraService.switchCamera(),
                              ),
                          ],
                        ),
                      ),

                      // Bottom Shutter Capture Button
                      Positioned(
                        bottom: 24,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: _handleCapture,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(color: Colors.white, width: 4),
                              ),
                              child: Center(
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
