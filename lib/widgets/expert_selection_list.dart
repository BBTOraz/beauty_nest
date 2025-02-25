import 'package:beauty_nest/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../model/expert_model.dart';
import '../viewmodels/booking_view_model.dart';


class ExpertSelectionList extends StatelessWidget {
  final VoidCallback? onExpertSelected;
  const ExpertSelectionList({super.key, this.onExpertSelected});

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final experts = BookingViewModel.experts;
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: experts.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final expert = experts[index];
          final bool isSelected = bookingVM.selectedExpert == expert;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () {
                bookingVM.selectExpert(expert);
                if (onExpertSelected != null) onExpertSelected!();
                showModalBottomSheet<DateTime>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => CustomDateTimePickerModal(
                    initialDateTime: DateTime(
                      bookingVM.selectedDate.year,
                      bookingVM.selectedDate.month,
                      bookingVM.selectedDate.day,
                      bookingVM.selectedTime?.hour ?? 9,
                      bookingVM.selectedTime?.minute ?? 0,
                    ),
                  ),
                ).then((result) {
                  if (result != null) {
                    final time = TimeOfDay(hour: result.hour, minute: result.minute);
                    bookingVM.updateTime(time);
                    bookingVM.updateDate(result);
                  }
                });
              },

              child: ExpertCard(
                expert: expert,
                isSelected: isSelected,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExpertCard extends StatelessWidget {
  final Expert expert;
  final bool isSelected;

  const ExpertCard({
    super.key,
    required this.expert,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Container(
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(expert.photoUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    expert.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expert.experienceRange,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.onPrimaryContainer, width: 2),
                  color: AppColors.onPrimaryContainer,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
        ],
    );
  }
}
