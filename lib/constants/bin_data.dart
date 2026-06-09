import 'package:flutter/material.dart';
 
class BinInfo {
  final String emoji;
  final String label;
  final Color color;
  final Color textColor;
  final List<String> examples;
 
  const BinInfo({
    required this.emoji,
    required this.label,
    required this.color,
    required this.textColor,
    required this.examples,
  });
}
 
class BinData {
  static const Map<String, BinInfo> bins = {
    'green': BinInfo(
      emoji: '🟢',
      label: 'Biodegradable & Organic Waste',
      color: Color(0xFF4CAF50),
      textColor: Color(0xFFFFFFFF),
      examples: [
        'Food scraps',
        'Fruit/vegetable peels',
        'Garden waste',
        'Tea bags',
        'Eggshells',
        'Flowers',
      ],
    ),
    'blue': BinInfo(
      emoji: '🔵',
      label: 'Dry & Recyclable Waste',
      color: Color(0xFF2196F3),
      textColor: Color(0xFFFFFFFF),
      examples: [
        'Paper',
        'Cardboard',
        'Plastic bottles',
        'Glass',
        'Metal cans',
        'Aluminum foil',
      ],
    ),
    'red': BinInfo(
      emoji: '🔴',
      label: 'Hazardous / Biomedical Waste',
      color: Color(0xFFF44336),
      textColor: Color(0xFFFFFFFF),
      examples: [
        'Batteries',
        'Chemicals',
        'Paint',
        'Pesticides',
        'Syringes',
        'Expired medicines',
      ],
    ),
    'yellow': BinInfo(
      emoji: '🟡',
      label: 'Sanitary & Medical Waste',
      color: Color(0xFFFFEB3B),
      textColor: Color(0xFF000000),
      examples: [
        'Used masks',
        'Gloves',
        'Diapers',
        'Sanitary pads',
        'Bandages',
        'Cotton swabs',
      ],
    ),
    'black': BinInfo(
      emoji: '⚫',
      label: 'General Waste',
      color: Color(0xFF424242),
      textColor: Color(0xFFFFFFFF),
      examples: [
        'Chips packets',
        'Broken toys',
        'Styrofoam',
        'Ceramic',
        'Non-recyclable mixed waste',
      ],
    ),
  };
 
  /// Maps ML model output class to bin color key
  static const Map<String, String> classToBin = {
    'food_waste': 'green',
    'vegetable_peels': 'green',
    'garden-waste': 'green',
    'other-organic': 'green',
    'food-waste': 'green',
    'paper': 'blue',
    'cardboard': 'blue',
    'plastic': 'blue',
    'glass': 'blue',
    'TextileFabric': 'blue',
    'metal': 'blue',
    'battery': 'red',
    'e-waste': 'red',
    'chemical': 'red',
    'syringe': 'red',
    'medicines': 'red',
    'mask': 'yellow',
    'masks': 'yellow',
    'gloves': 'yellow',
    'diaper': 'yellow',
    'bandage': 'yellow',
    'chips_packet': 'black',
    'styrofoam': 'black',
    'ceramic': 'black',
    'trash': 'black',
  };
 
  /// Confidence threshold — below this, show "not sure" fallback
  static const double confidenceThreshold = 0.75;
 
  /// Lookup helper
  static BinInfo? getBinForClass(String className) {
    final binKey = classToBin[className];
    if (binKey == null) return null;
    return bins[binKey];
  }
}