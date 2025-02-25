import 'package:flutter/material.dart';
import '../model/expert_model.dart';

class BookingViewModel extends ChangeNotifier {
  static final List<Expert> experts = [
    Expert(
      photoUrl: 'assets/workers/10.jpg',
      name: 'Bella Grace',
      info: 'Hair Stylish',
      experienceRange: '6 yrs exp',
      rating: 4.9,
    ),
    Expert(
      photoUrl: 'assets/workers/11.jpg',
      name: 'Daisy Scarlett',
      info: 'Hair Spa',
      experienceRange: '5 yrs exp',
      rating: 4.8,
    ),
    Expert(
      photoUrl: 'assets/workers/12.jpg',
      name: 'Daisy Scarlett',
      info: 'Hair Spa',
      experienceRange: '5 yrs exp',
      rating: 4.8,
    ),
    Expert(
      photoUrl: 'assets/workers/1.jpeg',
      name: 'Daisy Scarlett',
      info: 'Hair Spa',
      experienceRange: '5 yrs exp',
      rating: 4.8,
    ),
    Expert(
      photoUrl: 'assets/procare2.jpg',
      name: 'Daisy Scarlett',
      info: 'Hair Spa',
      experienceRange: '5 yrs exp',
      rating: 4.8,
    ),
  ];

  Expert? selectedExpert;
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  void selectExpert(Expert expert) {
    selectedExpert = expert;
    notifyListeners();
  }

  void selectExpertFromExternal(Expert? expert) {
    if (expert != null) {
      selectedExpert = expert;
      notifyListeners();
    }
  }

  void updateDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

}
