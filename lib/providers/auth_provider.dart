import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> login(String username, String password) async {
    final user = await DatabaseService.instance.getUser(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final existingUser =
    await DatabaseService.instance.getUser(username, password);
    if (existingUser == null) {
      await DatabaseService.instance.insertUser(
        User(id: 0, username: username, password: password),
      );
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
