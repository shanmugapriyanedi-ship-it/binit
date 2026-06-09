import 'package:flutter/material.dart';
import 'package:binit/constants/bin_data.dart';

class BinGuideScreen extends StatelessWidget {
const BinGuideScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF1A1A2E),
appBar: AppBar(
title: const Text('Bin Guide'),
backgroundColor: const Color(0xFF16213E),
foregroundColor: Colors.white,
),
body: ListView. builder(
padding: const EdgeInsets.all(16),
itemCount: BinData.bins. length,
itemBuilder: (context, index) {
final entry = BinData.bins.entries. elementAt(index);
final bin = entry.value;

return Container(
margin: const EdgeInsets.only(bottom: 16),
decoration: BoxDecoration(
color: bin.color.withValues(alpha: 0.15),
borderRadius: BorderRadius.circular(16),
border: Border.all(color: bin.color.withValues(alpha: 0.4)),
),
child: Theme(
data: Theme.of(context) .copyWith(
dividerColor: Colors.transparent,
),
child: ExpansionTile(
leading: Text(bin.emoji, style: const TextStyle(fontSize: 28)),
title: Text(
bin.label,
style: TextStyle(
color: bin.textColor == Colors.black
? Colors.white:bin.color,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
iconColor: Colors.white54,
collapsedIconColor: Colors.white38,
children: [
Padding(
padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
child: Wrap(
spacing: 8,
runSpacing: 8,
children: bin.examples.map((example) {
return Chip(
label: Text(
example,
style: const TextStyle(
color: Colors.white,
fontSize: 13,
),
),
backgroundColor: bin.color.withValues(alpha: 0.3),
side: BorderSide.none,
);
}).toList(),
),
),
],
),
),
);
}
),
);
}
}