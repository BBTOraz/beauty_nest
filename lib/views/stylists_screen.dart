import 'package:flutter/material.dart';

class StylistsScreen extends StatelessWidget {
  const StylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Стилисты', style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
