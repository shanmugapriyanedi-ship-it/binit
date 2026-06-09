import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:binit/screens/result_screen.dart';
import 'package:binit/screens/bin_guide_screen.dart';
import 'package:binit/models/classification_result.dart';
import 'package:binit/services/classifier_service.dart' hide ClassificationResult;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final ClassifierService _classifier = ClassifierService();
  bool _isProcessing = false;
  bool _modelReady = false;
  String _modelStatus = 'Loading model...';

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    final success = await _classifier.loadModel();
    if (mounted) {
      setState(() {
        _modelReady = success;
        _modelStatus = success ? 'Model ready' : 'Model failed to load';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!_modelReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⏳ Model is still loading, please wait...')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 224,
        maxHeight: 224,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() => _isProcessing = true);

      final Uint8List imageBytes = await pickedFile.readAsBytes();

      // Convert to base64 data URL for TFJS
      final base64Str = base64Encode(imageBytes);
      final dataUrl = 'data:image/jpeg;base64,$base64Str';

      // Run ML inference
      final mlResult = await _classifier.classify(dataUrl);

      if (mlResult == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Classification failed. Try again.')),
          );
        }
        return;
      }

      // Convert to app's ClassificationResult
      final result = ClassificationResult.fromPrediction(
        modelClass: mlResult.className,
        confidence: mlResult.confidence,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              imageBytes: imageBytes,
              result: result,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('BinIt 🗑️'),
        centerTitle: true,
        backgroundColor: const Color(0xFF16213E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Bin Guide',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BinGuideScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: _isProcessing
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Classifying...',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.recycling,
                    size: 100,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'What waste do you have?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Take a photo or pick from gallery',
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),

                  // Model status indicator
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _modelReady ? Icons.check_circle : Icons.hourglass_top,
                        color: _modelReady ? Colors.green : Colors.orange,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _modelStatus,
                        style: TextStyle(
                          color: _modelReady ? Colors.green : Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),
                  // Camera button
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, size: 24),
                    label: const Text('Take Photo', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Gallery button
                  OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library, size: 24),
                    label: const Text('Pick from Gallery', style: TextStyle(fontSize: 18)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}