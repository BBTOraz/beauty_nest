import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Запись', style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
