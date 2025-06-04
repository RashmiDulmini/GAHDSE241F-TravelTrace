import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userId = '';
  String _userName = '';
  String _fullName = '';
  String _email = '';
  String _role = '';
  String _address = '';
  String _contact = '';

  String get userId => _userId;
  String get userName => _userName;
  String get fullName => _fullName;
  String get email => _email;
  String get role => _role;
  String get address => _address;
  String get contact => _contact;

  void setUserInfo({
    required String userId,
    required String userName,
    required String fullName,
    required String email,
    required String role,
    String address = '',
    String contact = '',
  }) {
    _userId = userId;
    _userName = userName;
    _fullName = fullName;
    _email = email;
    _role = role;
    _address = address;
    _contact = contact;
    notifyListeners();
  }

  void clearUser() {
    _userId = '';
    _userName = '';
    _fullName = '';
    _email = '';
    _role = '';
    _address = '';
    _contact = '';
    notifyListeners();
  }

  // Optional: update only partial fields (for profile updates)
  void updateProfile({
    String? fullName,
    String? userName,
    String? email,
    String? address,
    String? contact,
  }) {
    if (fullName != null) _fullName = fullName;
    if (userName != null) _userName = userName;
    if (email != null) _email = email;
    if (address != null) _address = address;
    if (contact != null) _contact = contact;
    notifyListeners();
  }
}
