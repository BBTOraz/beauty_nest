import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/expert_model.dart';

class BookingViewModel extends ChangeNotifier {
  List<Expert> experts = [];
  Expert? selectedExpert;
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  BookingViewModel() {
    fetchExperts();
  }

  Future<void> fetchExperts() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('stylists').get();
      experts = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final firstName = data['firstName'] ?? '';
        final lastName = data['lastName'] ?? '';
        final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
        return Expert(
          name: '$firstName $lastName',
          info: data['specialization'] ?? '',
          experienceRange: '${data['experience'] ?? 0} лет',
          rating: double.parse(rating.toStringAsFixed(2)),
          photoUrl: data['photo'] ?? '',
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching experts: $e');
    }
  }

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

  void updateTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
