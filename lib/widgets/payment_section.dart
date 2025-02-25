// lib/widgets/payment_section.dart
import 'package:beauty_nest/viewmodels/auth_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../viewmodels/booking_view_model.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});
  @override
  _PaymentSectionState createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _saveCard = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = '1000';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final currentUserVM = Provider.of<AuthViewModel>(context, listen: false);
    final orderNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final orderData = {
      'stylist': bookingVM.selectedExpert?.name ?? '',
      'date': bookingVM.selectedDate.toIso8601String(),
      'time': bookingVM.selectedTime != null
          ? '${bookingVM.selectedTime!.hour.toString().padLeft(2, '0')}:${bookingVM.selectedTime!.minute.toString().padLeft(2, '0')}'
          : '',
      'address': currentUserVM.userModel?.address,
      'amount': _amountController.text.trim(),
      'orderNumber': orderNumber,
      'timestamp': FieldValue.serverTimestamp(),
    };
    try {
      await FirebaseFirestore.instance.collection('orders').add(orderData);
      if (_saveCard) {
        // Сохранение данных карты без CVV можно реализовать здесь
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Оплата успешна')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка оплаты: $e')));
    }
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Номер карты', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Срок (MM/YY)', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'CVV', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Сумма (тенге)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _saveCard,
                onChanged: (value) => setState(() => _saveCard = value ?? false),
              ),
              const Text('Сохранить карту'),
            ],
          ),
          const SizedBox(height: 16),
          _isProcessing
              ? const CircularProgressIndicator()
              : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Оплатить', style: TextStyle(fontSize: 16, color: AppColors.onPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}
