
import 'package:beauty_nest/viewmodels/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/user_repository.dart';
import '../service_locator.dart';
import '../utils/phone_utils.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();

  User? _user;
  User? get user => _user;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  AuthViewModel() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _user = user;
      _isInitialized = true;
      if (_user != null) {
        await loadUserData();
      }
      notifyListeners();
    });
  }

  Future<void> loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();
    if (doc.exists) {
      _userModel = UserModel.fromFirestore(doc);
    }
  }

  Future<void> loginWithPhone(String phone, String password) async {
    _setLoading(true);
    try {
      String email = phoneToEmail(phone);
      final user = await _userRepository.login(email, password);
      _user = user;
      _error = null;
      if (_user != null) {
        await loadUserData();
      }
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> registerWithPhone({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    required String city,
  }) async {
    _setLoading(true);
    try {
      String email = phoneToEmail(phone);
      final user = await _userRepository.register(email, password);
      _user = user;
      _error = null;
      if (_user != null) {
        final userModel = UserModel(
          uid: _user!.uid,
          email: _user!.email ?? '',
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          city: city,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .set(userModel.toMap());
      }
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }


  Future<void> logout() async {
    await _userRepository.logout();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
