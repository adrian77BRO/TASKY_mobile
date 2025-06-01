import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasky/core/network/api_service.dart';
import 'package:tasky/core/network/token_service.dart';
import 'package:tasky/task/data/models/task.dart';

class TaskRepository {
  Future<List<Task>> fetchTasks() async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/task'),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List tasksJson = data['tasks'];
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener tareas');
    }
  }

  Future<List<Task>> fetchTasksByStatus(String status) async {
    final token = await TokenService.getToken();

    final uri = status == 'all'
      ? Uri.parse('$baseUrl/task')
      : Uri.parse('$baseUrl/task/search?status=$status');

    final response = await http.get(
      uri,
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List tasksJson = data['tasks'];
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error al filtrar tareas');
    }
  }
}
