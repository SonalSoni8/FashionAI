import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../theme/aura_colors.dart';
import '../theme/aura_typography.dart';
import 'morphing_button.dart';

class RealCameraPreviewWidget extends StatefulWidget {
  final Function(String imagePath) onPictureTaken;

  const RealCameraPreviewWidget({
    super.key,
    required this.onPictureTaken,
  });

  @override
  State<RealCameraPreviewWidget> createState() => _RealCameraPreviewWidgetState();
}

class _RealCameraPreviewWidgetState extends State<RealCameraPreviewWidget> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isInitializing = true;
  FlashMode _currentFlashMode = FlashMode.off;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        await _setupController(_cameras![_selectedCameraIndex]);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<void> _setupController(CameraDescription camera) async {
    _controller?.dispose();
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  void _toggleCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    setState(() => _isInitializing = true);
    _setupController(_cameras![_selectedCameraIndex]);
  }

  void _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final newMode = _currentFlashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    await _controller!.setFlashMode(newMode);
    setState(() => _currentFlashMode = newMode);
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile photo = await _controller!.takePicture();
      setState(() => _capturedImagePath = photo.path);
      widget.onPictureTaken(photo.path);
    } catch (e) {
      // Ignore exception if capture interrupted
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_capturedImagePath != null) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.file(
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

    if (_isInitializing || _controller == null || !_controller!.value.isInitialized) {
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
              const CircularProgressIndicator(color: AuraColors.auraViolet),
              const SizedBox(height: 16),
              Text(
                "Initializing Hardware Camera...",
                style: AuraTypography.bodyMedium(isDark: true),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          children: [
            CameraPreview(_controller!),

            // Top Flash & Flip Camera Control Overlay
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _currentFlashMode == FlashMode.torch
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFlash,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cameraswitch_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _toggleCamera,
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
                  onTap: _capturePhoto,
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
      ),
    );
  }
}
