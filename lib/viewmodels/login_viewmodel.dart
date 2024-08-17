import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class LoginViewModel {
  List<User> _users = [];
  static const String _loggedInKey = 'isLoggedIn';

  LoginViewModel() {
    _loadUsers();
  }
  //load users_list 
  Future<void> _loadUsers() async {
    final String response = await rootBundle.loadString('assets/users_list.json');
    final List<dynamic> data = json.decode(response);
    _users = data.map((json) => User.fromJson(json)).toList();
  }

  //set login status
  Future<void> _setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, isLoggedIn);
  }

  //check login status
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<bool> login(String email, String password) async {
    final user = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => User(email: '', password: ''),
    );

    if (user.email.isNotEmpty) {
      await _setLoggedIn(true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _setLoggedIn(false);
  }
}
