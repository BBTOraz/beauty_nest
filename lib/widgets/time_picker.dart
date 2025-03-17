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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Выберите день и время',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Date and Time Selection
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  // Date Selection
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final date = DateTime.now().add(Duration(days: index));
                          final dayAbbrev = _getDayAbbreviation(date);
                          final isSelected = date.year == selectedDateTime.year &&
                              date.month == selectedDateTime.month &&
                              date.day == selectedDateTime.day;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.onPrimaryContainer.withOpacity(0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              title: Text(
                                dayAbbrev,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.onPrimaryContainer : Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: isSelected
                                  ? Text(
                                  '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                                  style: TextStyle(color: AppColors.onPrimaryContainer),
                                  textAlign: TextAlign.center
                              )
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedDateTime = DateTime(date.year, date.month, date.day, selectedDateTime.hour, selectedDateTime.minute);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Hour and Minute Selection
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        // Hour Picker
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade200, width: 1),
                              ),
                            ),
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
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
                                  return Center(
                                    child: Text(
                                      hour.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: index == selectedDateTime.hour - 9 ? AppColors.onPrimaryContainer : Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                                childCount: 13,
                              ),
                            ),
                          ),
                        ),

                        // Minute Picker
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
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
                                return Center(
                                  child: Text(
                                    minute.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: index == allowedMinutes.indexOf(selectedDateTime.minute) ? AppColors.onPrimaryContainer : Colors.grey,
                                    ),
                                  ),
                                );
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

            // Confirm Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedDateTime);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Готово',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

  String _getDayAbbreviation(DateTime date) {
    final weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return weekdays[date.weekday - 1];
  }
}