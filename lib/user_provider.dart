import 'package:flutter/material.dart';
import 'user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile _user = UserProfile(
    id: '1',
    name: 'John Doe',
    email: 'johndoe@example.com',
    phoneNumber: '1234567890',
  );

  UserProfile get user => _user;

  void updateAddress(String newAddress) {
    _user.address = newAddress;
    notifyListeners();
  }
}
