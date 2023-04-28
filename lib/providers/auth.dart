import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/models/user.dart';

import '../utilities/crypt.dart';

const storage = FlutterSecureStorage();

class Auth with ChangeNotifier {
  String _token = "";
  bool _isAuth = false;
  User? _user;

  String get token {
    return _token;
  }

  set token(String token) {
    _token = token;

    notifyListeners();
  }

  bool get isAuth {
    return _isAuth;
  }

  set isAuth(bool isAuth) {
    _isAuth = isAuth;

    notifyListeners();
  }

  set user(User? user) {
    _user = user;

    notifyListeners();
  }

  User? get user {
    return _user;
  }

  void logout() {
    _isAuth = false;
    _token = "";
    _user = null;

    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    var result = await existUser(username, password).then((value) {
      final token = Crypt.encryptString('$username$password');
      storage.write(
        key: "jwt",
        value: token.base16,
      );
      if (value != null) {
        _token = token.base16;
        _isAuth = true;
        _user = value;

        notifyListeners();
        return true;
      } else {
        return false;
      }
    });
    return result;
  }

  Future<User?> existUser(
    String username,
    String password,
  ) async {
    // if (token.isEmpty) {
    //   return null;
    // } else {
    //   var request = await http
    //       .get(Uri.parse('http://127.0.0.1:8000/client/currentUser'), headers: {
    //     'Authorization': 'Bearer $token',
    //   });
    //   var result = Response.fromJson(jsonDecode(request.body.toString()));
    //   return result.success ? User.fromJson(result.value) : null;
    // }
    return User(id: 1, username: 'Mannlex', password: 'prueba');
  }
}
