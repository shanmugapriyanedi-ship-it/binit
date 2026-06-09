import 'package:flutter/material.dart';
import 'package:binit/screens/camera_screen.dart';

void main() {
  runApp(const BinItApp());
}

class BinItApp extends StatelessWidget {
  const BinItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BinIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CameraScreen(),
    );
  }
}