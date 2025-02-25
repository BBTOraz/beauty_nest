import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../model/branch_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final bool isSelected;
  final VoidCallback onTap;
  const ServiceCard({super.key, required this.service, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(service.imageUrl, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(service.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text('${service.price.toStringAsFixed(0)} тг', style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          Center(
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.onPrimaryContainer : Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                ),
                child: Center(
                  child: Icon(isSelected ? Icons.check : Icons.add, color: isSelected ? AppColors.onPrimary : AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
