import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/stylist.dart';

class StylistRepository {
  final FirebaseFirestore _firestore;

  StylistRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Stylist>> fetchStylists() async {
    try {
      final querySnapshot = await _firestore.collection('stylists').get();
      final stylists = querySnapshot.docs.map((doc) {
        return Stylist.fromMap(doc.data(), doc.id);
      }).toList();
      return stylists;
    } catch (e) {
      print('Error fetching stylists: $e');
      return [];
    }
  }

  Future<Stylist?> getStylistById(String id) async {
    try {
      final docSnapshot = await _firestore.collection('stylists').doc(id).get();
      if (docSnapshot.exists) {
        return Stylist.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error fetching stylist by ID: $e');
      return null;
    }
  }
}
