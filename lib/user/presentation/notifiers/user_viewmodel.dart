import 'package:flutter/material.dart';
import 'package:tasky/core/network/token_service.dart';
import 'package:tasky/user/data/models/login.dart';
import 'package:tasky/user/data/models/user.dart';
import 'package:tasky/user/data/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userService = UserRepository();
  bool isLoading = false;
  String? token;

  Future<String> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final result = await _userService.login(
      Login(email: email, password: password),
    );
    final body = result['body'];

    if (result['statusCode'] == 201 && body['status'] == 'success') {
      token = body['token'];
      await TokenService.saveToken(token!);
    }

    isLoading = false;
    notifyListeners();

    return body['message'] ?? 'Error desconocido';
  }

  Future<String> register(
    String username,
    String email,
    String password,
  ) async {
    isLoading = true;
    notifyListeners();

    final result = await _userService.register(
      User(email: email, password: password, username: username),
    );
    final body = result['body'];

    isLoading = false;
    notifyListeners();

    return body['message'] ?? 'Error desconocido';
  }
}
