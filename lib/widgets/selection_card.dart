// Изменённый класс SelectionCard (lib/widgets/selection_card.dart)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';

class SelectionCard extends StatelessWidget {
  final String stylist;
  final DateTime date;
  final TimeOfDay? time;
  const SelectionCard({super.key, required this.stylist, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd.MM.yyyy').format(date);
    final timeStr = time != null ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}' : 'Не выбрано';
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Стилист:', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Дата:', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Время:', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(stylist,),
                Text(dateStr),
                Text(timeStr),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
