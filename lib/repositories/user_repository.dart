import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

abstract class UserRepository {
  Future<User?> login(String email, String password);
  Future<User?> register(String email, String password);
  Future<void> logout();
  User? get currentUser;
}

class FirebaseUserRepository implements UserRepository {
  final AuthService _authService;
  FirebaseUserRepository(this._authService);

  @override
  Future<User?> login(String email, String password) async {
    return await _authService.signIn(email, password);
  }

  @override
  Future<User?> register(String email, String password) async {
    return await _authService.signUp(email, password);
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
  }

  @override
  User? get currentUser => _authService.currentUser;
}
