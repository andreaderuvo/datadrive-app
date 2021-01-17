import 'package:flutter/material.dart';

enum Status { Authenticated, Authenticating, Unauthenticated, Error }

class UserRepository with ChangeNotifier {
  Status _status = Status.Unauthenticated;

  Status get status => _status;

  Future<bool> signIn(String email, String password) async {
    _status = Status.Authenticated;
    notifyListeners();
    return true;
  }
}
