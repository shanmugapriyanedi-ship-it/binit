import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:binit/models/classification_result.dart';

class ResultScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final ClassificationResult result;

const ResultScreen({
super.key, 
required this.imageBytes, 
required this.result,
});

@override
Widget build (BuildContext context) {
return Scaffold(
backgroundColor: const Color (0xFF1A1A2E),
appBar: AppBar(
title: const Text('Result'),
backgroundColor: const Color (0xFF16213E),
foregroundColor: Colors.white,
),
body:Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: result.isConfident?_buildConfidentResult(context):_buildUnsureResult(context),
),
),
);
}
Widget _buildConfidentResult(BuildContext context) {
final bin = result.binInfo!;
return Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// Captured image
ClipRRect(
borderRadius: BorderRadius.circular (16),
child: Image.memory(
imageBytes,
width: 200,
height:200,
fit: BoxFit.cover,
),
),
const SizedBox (height: 24),
// Item name
Text(
result.itemName,
style:const TextStyle(
color:Colors.white,
fontSize:28,
fontWeight:FontWeight.bold,
),
),
const SizedBox (height: 16),
// Colored bin banner
Container(
width:
double.infinity,
padding: const EdgeInsets.symmetric (vertical: 20, horizontal: 16),
decoration:BoxDecoration(
color:bin.color,
borderRadius: BorderRadius.circular(16),
),
child:Column(
children:[
Text(
bin.emoji,
style: const TextStyle(fontSize: 40),
),
const SizedBox(height: 8),
Text(
result.resultMessage,
textAlign: TextAlign.center,
style:TextStyle(
color: bin.textColor,
fontSize:18,
fontWeight: FontWeight.w600,
),
),
],
),
),
const SizedBox (height: 16),

// Confidence score (subtle)
Text(
'${result.confidencePercent} confident',
style: const TextStyle(
color: Colors.white38,
fontSize: 14,
),
),
const SizedBox(height: 32),

// Scan Again button
ElevatedButton.icon(
onPressed: () => Navigator.pop(context),
icon: const Icon(Icons.camera_alt),
label: const Text('Scan Again', style: TextStyle(fontSize: 18)),
style: ElevatedButton. styleFrom(
backgroundColor: const Color(0xFF4CAF50),
foregroundColor: Colors.white,
padding: const EdgeInsets. symmetric(horizontal: 40, vertical: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(30),
),
),
),
],
);
}
Widget _buildUnsureResult(BuildContext context) {
return Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// Captured image
ClipRRect(
borderRadius: BorderRadius.circular(16),
child: Image.memory(
imageBytes,
width: 200,
height: 200,
fit: BoxFit.cover,
),
),
const SizedBox(height: 32),

// Unsure emoji
const Text('🤔', style: TextStyle(fontSize: 60)),
const SizedBox(height: 16),

// Fallback message
const Text(
"Hmm, I'm not sure about this one.",
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.white,
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
const Text(
'Try a different angle or better lighting.',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.white60, fontSize: 16),
),
const SizedBox(height: 12),

// Show low confidence
Text(
'Best guess: ${result.itemName} (${result.confidencePercent})',
style: const TextStyle(color: Colors.white30, fontSize: 13),
),
const SizedBox(height: 32),

// Try Again button
ElevatedButton. icon(
onPressed: () => Navigator.pop(context),
icon: const Icon(Icons.refresh),
label: const Text('Try Again', style: TextStyle(fontSize: 18)),
style: ElevatedButton. styleFrom(
backgroundColor: const Color(0xFF4CAF50),
foregroundColor: Colors.white,
padding: const EdgeInsets. symmetric(horizontal: 40, vertical: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(30),
),
),
),
],
);
}
}