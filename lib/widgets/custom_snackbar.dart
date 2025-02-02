
import 'package:flutter/material.dart';

enum SnackbarType { success, error, info }

void showCustomSnackBar(BuildContext context, String message, SnackbarType type) {
  Color backgroundColor;
  IconData icon;
  switch (type) {
    case SnackbarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case SnackbarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    default:
      backgroundColor = Colors.grey;
      icon = Icons.info;
      break;
  }
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
