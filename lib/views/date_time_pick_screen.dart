// lib/views/next_screen.dart
import 'package:flutter/material.dart';
import '../app_theme.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор даты и времени'), backgroundColor: AppColors.primary),
      body: Center(child: const Text('Здесь выбирается дата и время', style: TextStyle(fontSize: 18))),
    );
  }
}
