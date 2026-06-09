// ══════════════════════════════════════════════════════
// 🧠 BinIt — Classifier Service (Dart ↔ TFJS Bridge)
// ══════════════════════════════════════════════════════

import 'dart:js_interop';

/// JS interop type for the result from classifyImage()
extension type JSClassificationResult._(JSObject _) implements JSObject {
  external JSString get className;
  external JSNumber get confidence;
  external JSArray get allScores;
}

/// Result from the TFJS model inference
class ClassificationResult {
  final String className;
  final double confidence;
  final List<double> allScores;

  ClassificationResult({
    required this.className,
    required this.confidence,
    required this.allScores,
  });
}

// ── JS interop bindings ──

@JS('loadModel')
external JSPromise<JSBoolean> _jsLoadModel();

@JS('classifyImage')
external JSPromise<JSObject?> _jsClassifyImage(JSString imageSource);

/// Classifier service — singleton wrapper around TFJS calls
class ClassifierService {
  static final ClassifierService _instance = ClassifierService._internal();
  factory ClassifierService() => _instance;
  ClassifierService._internal();

  bool _isModelLoaded = false;
  bool _isLoading = false;

  bool get isModelLoaded => _isModelLoaded;
  bool get isLoading => _isLoading;

  /// Load the TFJS Graph Model (call once on app start)
  Future<bool> loadModel() async {
    if (_isModelLoaded) return true;
    if (_isLoading) return false;

    _isLoading = true;
    try {
      final result = await _jsLoadModel().toDart;
      _isModelLoaded = result.toDart;
      return _isModelLoaded;
    } catch (e) {
      //ignore: avoid_print
      print('[BinIt] ❌ Dart: Model load error: $e');
      return false;
    } finally {
      _isLoading = false;
    }
  }

  /// Classify an image from a base64 data URL
  /// Returns null if classification fails
  Future<ClassificationResult?> classify(String base64DataUrl) async {
    if (!_isModelLoaded) {
      //ignore: avoid_print
      print('[BinIt] ⚠️ Model not loaded yet');
      return null;
    }

    try {
      final jsObj = await _jsClassifyImage(base64DataUrl.toJS).toDart;
      if (jsObj == null) return null;
      final jsResult = jsObj as JSClassificationResult;

      final className = jsResult.className.toDart;
      final confidence = jsResult.confidence.toDartDouble;
      final jsScores = jsResult.allScores;

      final allScores = <double>[];
      for (int i = 0; i < jsScores.length; i++) {
        allScores.add((jsScores[i] as JSNumber).toDartDouble);
      }

      return ClassificationResult(
        className: className,
        confidence: confidence,
        allScores: allScores,
      );
    } catch (e) {
      //ignore: avoid_print
      print('[BinIt] ❌ Dart: Classification error: $e');
      return null;
    }
  }
}