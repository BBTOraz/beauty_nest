
import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.hintText = 'Введите номер телефона',
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final flagSize = mediaQuery.size.height * 0.03;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/flag.png',
                width: flagSize,
                height: flagSize,
              ),
              const SizedBox(width: 4),
              const Text(
                '+7',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите номер телефона';
              }
              // Дополнительная валидация (например, длина номера) при необходимости
              return null;
            },
          ),
        ),
      ],
    );
  }
}
