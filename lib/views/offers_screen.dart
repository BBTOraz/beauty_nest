import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Акции', style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
