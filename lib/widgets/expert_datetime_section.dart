import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../viewmodels/booking_view_model.dart';
import 'expert_selection_list.dart';
import 'selection_card.dart';

class ExpertAndDateTimeSelectionSection extends StatelessWidget {
  const ExpertAndDateTimeSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExpertSelectionList(),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: const [
              Icon(Icons.info, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(child: Text('Нажмите на стилиста для выбора выбора времени', style: TextStyle(color: AppColors.textPrimary))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SelectionCard(
          stylist: bookingVM.selectedExpert?.name ?? 'Стилист не выбран',
          date: bookingVM.selectedDate,
          time: bookingVM.selectedTime,
        ),
      ],
    );
  }
}
