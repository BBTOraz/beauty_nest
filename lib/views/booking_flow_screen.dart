// --- Изменения в файле lib/views/booking_flow_screen.dart ---
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../model/expert_model.dart';
import '../viewmodels/booking_view_model.dart';
import '../widgets/booking_timeline.dart';
import '../widgets/expert_datetime_section.dart';
import '../widgets/payment_section.dart';
import '../widgets/personal_data_section.dart';

class BookingFlowScreen extends StatelessWidget {
  final Expert? selectedExpert;
  const BookingFlowScreen({Key? key, this.selectedExpert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookingViewModel>(
      create: (_) => BookingViewModel()..selectExpertFromExternal(selectedExpert),
      child: const BookingFlowContent(),
    );
  }
}

class BookingFlowContent extends StatefulWidget {
  const BookingFlowContent({Key? key}) : super(key: key);

  @override
  _BookingFlowContentState createState() => _BookingFlowContentState();
}

class _BookingFlowContentState extends State<BookingFlowContent> {
  int activeStep = 0;

  void _goNext() {
    setState(() {
      if (activeStep < 3) {
        activeStep++;
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  void _goBack() {
    if (activeStep > 0) {
      setState(() {
        activeStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildContentForStep() {
    switch (activeStep) {
      case 0:
        return const ExpertAndDateTimeSelectionSection();
      case 1:
        return const PersonalDataSection();
      case 2:
        return const PaymentSection();
      case 3:
        return Center(child: Text('Завершение', style: Theme.of(context).textTheme.titleLarge));
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бронирование стилиста'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBack),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          HorizontalTimeline(activeStep: activeStep),
          const SizedBox(height: 16),
          Expanded(child: _buildContentForStep()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _goNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Next', style: TextStyle(fontSize: 16, color: AppColors.onPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}
