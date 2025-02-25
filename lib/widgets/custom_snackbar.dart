
import 'package:beauty_nest/app_theme.dart';
import 'package:flutter/material.dart';

enum SnackbarType { success, error, info }

void showCustomSnackBar(BuildContext context, String message, SnackbarType type) {
  Color backgroundColor;
  IconData icon;
  switch (type) {
    case SnackbarType.success:
      backgroundColor = AppColors.success;
      icon = Icons.check_circle;
      break;
    case SnackbarType.error:
      backgroundColor = AppColors.error;
      icon = Icons.error;
      break;
    default:
      backgroundColor = AppColors.secondaryContainer;
      icon = Icons.info;
      break;
  }
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(icon, color: AppColors.onPrimary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message, style: const TextStyle(color: AppColors.onPrimary)),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 52, vertical: 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
