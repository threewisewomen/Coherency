import 'package:flutter/material.dart';

void main() {
  // Later, we will add service locator setup and other initializations here.
  runApp(const CoherencyApp());
}

class CoherencyApp extends StatelessWidget {
  const CoherencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coherency',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Coherency'),
        ),
        body: const Center(
          child: Text('Frontend Foundation: Secure and Operational.'),
        ),
      ),
    );
  }
}
