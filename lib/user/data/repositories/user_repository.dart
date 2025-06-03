import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasky/core/network/endpoints.dart';
import 'package:tasky/user/data/datasource/user_service.dart';
import 'package:tasky/user/data/models/login.dart';
import 'package:tasky/user/data/models/user.dart';

class UserApiRepository implements IUserService {
  @override
  Future<Map<String, dynamic>> login(Login user) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  @override
  Future<Map<String, dynamic>> register(User user) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }
}