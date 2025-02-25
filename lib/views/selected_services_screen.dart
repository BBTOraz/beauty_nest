// lib/views/selected_services_screen.dart
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../model/branch_model.dart';

class SelectedServicesScreen extends StatelessWidget {
  final Branch branch;
  final Set<int> selectedServices;
  final Set<int> selectedPackages;
  const SelectedServicesScreen({super.key, required this.branch, required this.selectedServices, required this.selectedPackages});
  double _calculateTotal() {
    double total = 0;
    for (int index in selectedServices) {
      total += branch.services[index].price;
    }
    for (int index in selectedPackages) {
      total += branch.services[index].price;
    }
    return total;
  }
  @override
  Widget build(BuildContext context) {
    final selectedItems = [
      ...selectedServices.map((i) => branch.services[i]),
      ...selectedPackages.map((i) => branch.services[i]),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Выбранные услуги'), backgroundColor: AppColors.primary),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final item = selectedItems[index];
                  return ListTile(
                    title: Text(item.title),
                    trailing: Text('${item.price.toStringAsFixed(0)} тг'),
                  );
                },
              ),
            ),
            const Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${_calculateTotal().toStringAsFixed(0)} тг', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
