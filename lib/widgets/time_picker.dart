// Изменённый CustomDateTimePickerModal (lib/widgets/custom_date_time_picker_modal.dart)
import 'package:flutter/material.dart';
import '../app_theme.dart';

class CustomDateTimePickerModal extends StatefulWidget {
  final DateTime initialDateTime;
  const CustomDateTimePickerModal({super.key, required this.initialDateTime});

  @override
  _CustomDateTimePickerModalState createState() => _CustomDateTimePickerModalState();
}

class _CustomDateTimePickerModalState extends State<CustomDateTimePickerModal> {
  late DateTime selectedDateTime;
  final List<int> allowedMinutes = [0, 15, 30, 45];

  @override
  void initState() {
    super.initState();
    final initHour = widget.initialDateTime.hour < 9 ? 9 : widget.initialDateTime.hour > 21 ? 21 : widget.initialDateTime.hour;
    selectedDateTime = DateTime(widget.initialDateTime.year, widget.initialDateTime.month, widget.initialDateTime.day, initHour, allowedMinutes.first);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Выберите день и время', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index));
                      final dayAbbrev = _getDayAbbreviation(date);
                      final isSelected = date.year == selectedDateTime.year && date.month == selectedDateTime.month && date.day == selectedDateTime.day;
                      return ListTile(
                        dense: true,
                        title: Text(dayAbbrev, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.onPrimaryContainer : Colors.grey), textAlign: TextAlign.center),
                        subtitle: isSelected ? Text('${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}', textAlign: TextAlign.center) : null,
                        onTap: () {
                          setState(() {
                            selectedDateTime = DateTime(date.year, date.month, date.day, selectedDateTime.hour, selectedDateTime.minute);
                          });
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          controller: FixedExtentScrollController(initialItem: selectedDateTime.hour - 9),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              final hour = 9 + index;
                              selectedDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, hour, selectedDateTime.minute);
                            });
                          },
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              if (index < 0 || index > 12) return null;
                              final hour = 9 + index;
                              return Center(child: Text(hour.toString().padLeft(2, '0')));
                            },
                            childCount: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          controller: FixedExtentScrollController(initialItem: allowedMinutes.indexOf(selectedDateTime.minute)),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              final minute = allowedMinutes[index];
                              selectedDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, selectedDateTime.hour, minute);
                            });
                          },
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              if (index < 0 || index >= allowedMinutes.length) return null;
                              final minute = allowedMinutes[index];
                              return Center(child: Text(minute.toString().padLeft(2, '0')));
                            },
                            childCount: allowedMinutes.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedDateTime);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Готово', style: TextStyle(fontSize: 16, color: AppColors.onPrimary)),
          ),
        ],
      ),
    );
  }

  String _getDayAbbreviation(DateTime date) {
    final weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return weekdays[date.weekday - 1];
  }
}
