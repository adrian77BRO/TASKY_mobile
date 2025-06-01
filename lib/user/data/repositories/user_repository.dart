import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasky/core/network/api_service.dart';
import 'package:tasky/user/data/models/login.dart';
import 'package:tasky/user/data/models/user.dart';

class UserRepository {
  Future<Map<String, dynamic>> login(Login user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  Future<Map<String, dynamic>> register(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }
}
