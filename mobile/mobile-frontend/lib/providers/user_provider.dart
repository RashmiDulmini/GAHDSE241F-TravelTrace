import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userId = '';
  String _userName = '';
  String _fullName = '';
  String _email = '';
  String _role = '';

  String get userId => _userId;
  String get userName => _userName;
  String get fullName => _fullName;
  String get email => _email;
  String get role => _role;

  void setUserInfo({
    required String userId,
    required String userName,
    required String fullName,
    required String email,
    required String role,
  }) {
    _userId = userId;
    _userName = userName;
    _fullName = fullName;
    _email = email;
    _role = role;
    notifyListeners();
  }

  void clearUser() {
    _userId = '';
    _userName = '';
    _fullName = '';
    _email = '';
    _role = '';
    notifyListeners();
  }
}
