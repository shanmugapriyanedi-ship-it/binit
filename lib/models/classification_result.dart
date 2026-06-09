import 'package:binit/constants/bin_data.dart';

class ClassificationResult {
final String itemName;
final String modelClass;
final double confidence;
final BinInfo? binInfo;
final String binColor;

const ClassificationResult({
required this.itemName,
required this.modelClass,
required this.confidence,
required this.binInfo,
required this.binColor,
});

/// Creates a result from ML model output
factory ClassificationResult.fromPrediction({
required String modelClass,
required double confidence,
}) {
final binKey = BinData.classToBin[modelClass] ?? 'black';
final binInfo = BinData.bins [binKey];

// Convert model class to display-friendly name
// e.g., "food_waste" + "Food Waste"
final itemName = modelClass
.split('_')
.map((w) => w[0].toUpperCase() + w.substring(1))
.join('');

return ClassificationResult(
itemName: itemName,
modelClass: modelClass,
confidence: confidence,
binInfo: binInfo,
binColor: binKey,
);
}

/// Is the model confident enough?
bool get isConfident => confidence >= BinData.confidenceThreshold;

/// Formatted confidence for display - e.g., "92%"
String get confidencePercent => '${(confidence * 100).toStringAsFixed(0)}%';

/// The message shown on the result card
/// e.g., "Put this in the Green bin 🟢 - Biodegradable & Organic Waste"
String get resultMessage {
  if (binInfo == null) return 'Unknown waste type';
  return 'Put this in the ${binColor[0].toUpperCase()}${binColor. substring(1)} '
      'bin ${binInfo!. emoji} - ${binInfo!. label}';
 }
}
