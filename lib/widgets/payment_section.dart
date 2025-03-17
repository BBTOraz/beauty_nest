import 'package:beauty_nest/viewmodels/auth_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../viewmodels/booking_view_model.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  _PaymentSectionState createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _saveCard = false;
  bool _isProcessing = false;
  bool _isCardSaved = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = '25000';
    _loadSavedCardData();
  }

  Future<void> _loadSavedCardData() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authVM.userModel?.uid;
    if (userId == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          final savedCardNumber = data['cardNumber'] ?? '';
          final savedExpiry = data['expiry'] ?? '';
          if (savedCardNumber.isNotEmpty && savedExpiry.isNotEmpty) {
            setState(() {
              _cardNumberController.text = savedCardNumber;
              _expiryController.text = savedExpiry;
              _isCardSaved = true;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading saved card: $e');
    }
  }

  /// Валидация номера карты
  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите номер карты';
    }
    final cleanedValue = value.replaceAll(' ', '');
    if (cleanedValue.length != 16) {
      return 'Номер карты должен содержать 16 цифр';
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.isEmpty) return 'Введите срок карты (ММ/ГГ)';
    if (value.length != 5) {
      return 'Формат: ММ/ГГ';
    }
    // Проверяем шаблон
    if (!RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(value)) {
      return 'Некорректный формат (ММ/ГГ)';
    }
    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;
    final now = DateTime.now();
    final expiryDate = DateTime(2000 + year, month + 1);

    if (expiryDate.isBefore(now)) {
      return 'Карта просрочена';
    }
    return null;
  }

  /// Валидация CVV
  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) return 'Введите CVV';
    if (!RegExp(r'^\d{3}$').hasMatch(value)) {
      return 'CVV должен содержать 3 цифры';
    }
    return null;
  }


  /// Обработка нажатия на кнопку "Оплатить"
  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final currentUserVM = Provider.of<AuthViewModel>(context, listen: false);
    final userId = currentUserVM.userModel?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пользователь не авторизован'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isProcessing = false);
      return;
    }

    // Допустим, при оплате создаём объект "заказ" в массиве "atHome" пользователя
    final orderNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final orderData = {
      'stylist': bookingVM.selectedExpert?.name ?? '',
      'date': bookingVM.selectedDate.toIso8601String(),
      'time': bookingVM.selectedTime != null
          ? '${bookingVM.selectedTime!.hour.toString().padLeft(2, '0')}:${bookingVM.selectedTime!.minute.toString().padLeft(2, '0')}'
          : '',
      'address': currentUserVM.userModel?.address,
      'amount': _amountController.text.trim(),
      'img': bookingVM.selectedExpert?.photoUrl ?? '',
      'orderNumber': orderNumber,
      'timestamp': Timestamp.now(),
    };

    try {
      if (_saveCard) {
        await _saveCardToUserDoc(userId);
      }

      // Далее сохраняем заказ в массив atHome
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'atHome': FieldValue.arrayUnion([orderData])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Оплата успешна'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка оплаты: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isProcessing = false);
  }

  /// Сохраняем карту в полях документа пользователя (cardNumber, expiry)
  Future<void> _saveCardToUserDoc(String userId) async {
    final cardNumberClean = _cardNumberController.text.replaceAll(RegExp(r'[\s-]'), '');
    final expiry = _expiryController.text;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'cardNumber': cardNumberClean,
        'expiry': expiry,
      });
      // При желании можно выставить _isCardSaved = true
      setState(() {
        _isCardSaved = true;
      });
    } catch (e) {
      debugPrint('Error saving card to user doc: $e');
      // Можно бросить исключение выше или просто обработать
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Номер карты: строго 16 цифр
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                // Фильтруем только цифры
                FilteringTextInputFormatter.digitsOnly,
                // Специальный форматтер, который не даёт ввести больше 16 цифр
                _CardNumberFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Номер карты',
                prefixIcon: Icon(Icons.credit_card),
              ),
              validator: _validateCardNumber,
            ),
            const SizedBox(height: 16),

            // Срок (MM/YY) и CVV
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      _ExpiryDateFormatter(), // Кастомный форматтер
                      LengthLimitingTextInputFormatter(5),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Срок (ММ/ГГ)',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: _validateExpiry,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: _validateCVV,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Сумма
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сумма (тенге)',
                prefixIcon: Icon(Icons.monetization_on),
              ),
            ),
            const SizedBox(height: 16),

            // Сохранить карту
            Row(
              children: [
                Checkbox(
                  value: _saveCard,
                  onChanged: (value) {
                    setState(() {
                      _saveCard = value ?? false;
                    });
                  },
                ),
                const Text('Сохранить карту'),
                const Spacer(),
                if (_isCardSaved)
                  Text(
                    'Карта сохранена',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
            _isProcessing
                ? Center(
              child: CircularProgressIndicator(
                color: AppColors.onPrimaryContainer,
              ),
            )
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Оплатить',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

/// Кастомный форматтер для номера карты (строго 16 цифр).
/// Автоматически добавляет пробелы каждые 4 символа.
/// Не позволяет ввести более 16 цифр.
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Удаляем все пробелы
    String digits = newValue.text.replaceAll(' ', '');

    // Если пользователь пытается ввести более 16 цифр - обрезаем
    if (digits.length > 16) {
      digits = digits.substring(0, 16);
    }

    // Форматируем, вставляя пробел каждые 4 цифры
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final indexPlusOne = i + 1;
      if (indexPlusOne % 4 == 0 && indexPlusOne != digits.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Кастомный форматтер для срока действия (ММ/ГГ).
/// Автоматически вставляет '/' после ввода двух цифр.
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Удаляем всё, кроме цифр и слэша
    String filtered = newValue.text.replaceAll(RegExp(r'[^0-9/]'), '');

    // Если первый символ слэш — убираем
    if (filtered.startsWith('/')) {
      filtered = filtered.substring(1);
    }

    // Автоматически вставляем '/' после двух цифр
    if (filtered.length > 2 && !filtered.contains('/')) {
      filtered = '${filtered.substring(0, 2)}/${filtered.substring(2)}';
    }

    // Если пользователь удалил символ и осталось "06/" - допустим
    // Если есть повторный '/', тоже убираем
    final slashCount = '/'.allMatches(filtered).length;
    if (slashCount > 1) {
      // убираем все слэши, кроме первого
      final firstSlashIndex = filtered.indexOf('/');
      filtered = filtered.substring(0, firstSlashIndex + 1) +
          filtered.substring(firstSlashIndex + 1).replaceAll('/', '');
    }

    // Обрезаем до 5 символов (например "06/26")
    if (filtered.length > 5) {
      filtered = filtered.substring(0, 5);
    }

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}