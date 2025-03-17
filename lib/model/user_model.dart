import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String city;
  final String phone;
  final String address;
  final List<dynamic> atHome;
  final List<dynamic> booking;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.phone,
    required this.address,
    this.atHome = const [],
    this.booking = const [],
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      city: data['city'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      atHome: data['atHome'] is List ? List.from(data['atHome']) : [],
      booking: data['bookings'] is List ? List.from(data['bookings']) : [],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'city': city,
      'phone': phone,
      'address': address,
      'atHome': atHome,
      'booking': booking,
    };
  }
}
