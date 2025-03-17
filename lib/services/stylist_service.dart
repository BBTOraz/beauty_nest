import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/stylist.dart';
import '../repositories/stylist_repository.dart';

class StylistService extends ChangeNotifier {
  final StylistRepository _repository;
  List<Stylist> _stylists = [];
  bool _isLoading = false;
  String? _error;

  StylistService({required StylistRepository repository})
      : _repository = repository;

  List<Stylist> get stylists => _stylists;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStylists() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stylists = await _repository.fetchStylists();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<Stylist?> getStylistById(String id) async {
    Stylist? stylist = _stylists.firstWhere(
          (stylist) => stylist.id == id,
      orElse: () => Stylist(
        id: '',
        firstName: '',
        lastName: '',
        photo: '',
        rating: 0,
        ratingCount: 0,
        commentCount: 0,
        quote: '',
        specialization: '',
        address: '',
        comments: [],
      ),
    );

    if (stylist.id.isEmpty) {
      // If not in list, fetch from repository
      return await _repository.getStylistById(id);
    }

    return stylist;
  }
}

