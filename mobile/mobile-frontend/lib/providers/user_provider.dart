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

  // Getters
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

  // Set all user info
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
    _userId = userId.trim();
    _userName = userName.trim();
    _fullName = fullName.trim();
    _email = email.trim();
    _role = role.trim();
    _address = address.trim();
    _contact = contact.trim();
    _profilePicture = profilePicture;
    _latitude = latitude;
    _longitude = longitude;
    _locationName = locationName?.trim();
    notifyListeners();
  }

  // Clear user info on logout
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

  // Update only profile picture
  void updateProfilePicture(String? profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }

  // Update location details
  void updateLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  }) {
    _latitude = latitude;
    _longitude = longitude;
    _locationName = locationName?.trim();
    notifyListeners();
  }

  // Update selective profile fields
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
    if (fullName != null) _fullName = fullName.trim();
    if (userName != null) _userName = userName.trim();
    if (email != null) _email = email.trim();
    if (address != null) _address = address.trim();
    if (contact != null) _contact = contact.trim();
    if (profilePicture != null) _profilePicture = profilePicture;
    if (latitude != null) _latitude = latitude;
    if (longitude != null) _longitude = longitude;
    if (locationName != null) _locationName = locationName.trim();
    notifyListeners();
  }

  // Convert user data to a Map (for API or local storage)
  Map<String, dynamic> toMap() {
    return {
      'userId': _userId,
      'userName': _userName,
      'fullName': _fullName,
      'email': _email,
      'role': _role,
      'address': _address,
      'contact': _contact,
      'profilePicture': _profilePicture,
      'latitude': _latitude,
      'longitude': _longitude,
      'locationName': _locationName,
    };
  }

  // Load user data from a Map (e.g., from API or SharedPreferences)
  void fromMap(Map<String, dynamic> map) {
    _userId = map['userId'] ?? '';
    _userName = map['userName'] ?? '';
    _fullName = map['fullName'] ?? '';
    _email = map['email'] ?? '';
    _role = map['role'] ?? '';
    _address = map['address'] ?? '';
    _contact = map['contact'] ?? '';
    _profilePicture = map['profilePicture'];
    _latitude = map['latitude']?.toDouble();
    _longitude = map['longitude']?.toDouble();
    _locationName = map['locationName'];
    notifyListeners();
  }
}
