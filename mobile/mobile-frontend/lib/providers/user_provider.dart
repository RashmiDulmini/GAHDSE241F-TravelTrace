import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userId = '';
  String _userName = '';
  String _fullName = '';
  String _email = '';
  String _role = '';
  String _address = '';
  String _contact = '';
  String? _profilePicture;
  double? _latitude;
  double? _longitude;
  String? _locationName;

  String get userId => _userId;
  String get userName => _userName;
  String get fullName => _fullName;
  String get email => _email;
  String get role => _role;
  String get address => _address;
  String get contact => _contact;
  String? get profilePicture => _profilePicture;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get locationName => _locationName;

  void setUserInfo({
    required String userId,
    required String userName,
    required String fullName,
    required String email,
    required String role,
    String address = '',
    String contact = '',
    String? profilePicture,
    double? latitude,
    double? longitude,
    String? locationName,
  }) {
    _userId = userId;
    _userName = userName;
    _fullName = fullName;
    _email = email;
    _role = role;
    _address = address;
    _contact = contact;
    _profilePicture = profilePicture;
    _latitude = latitude;
    _longitude = longitude;
    _locationName = locationName;
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
    _profilePicture = null;
    _latitude = null;
    _longitude = null;
    _locationName = null;
    notifyListeners();
  }

  void updateProfilePicture(String? profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }

  void updateLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  }) {
    _latitude = latitude;
    _longitude = longitude;
    _locationName = locationName;
    notifyListeners();
  }

  // Optional: update only partial fields (for profile updates)
  void updateProfile({
    String? fullName,
    String? userName,
    String? email,
    String? address,
    String? contact,
    String? profilePicture,
    double? latitude,
    double? longitude,
    String? locationName,
  }) {
    if (fullName != null) _fullName = fullName;
    if (userName != null) _userName = userName;
    if (email != null) _email = email;
    if (address != null) _address = address;
    if (contact != null) _contact = contact;
    if (profilePicture != null) _profilePicture = profilePicture;
    if (latitude != null) _latitude = latitude;
    if (longitude != null) _longitude = longitude;
    if (locationName != null) _locationName = locationName;
    notifyListeners();
  }
}
