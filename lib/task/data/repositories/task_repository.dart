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

    final uri =
        status == 'all'
            ? Uri.parse('$baseUrl/task')
            : Uri.parse('$baseUrl/task/search?status=$status');

    final response = await http.get(uri, headers: {'Authorization': '$token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List tasksJson = data['tasks'];
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error al filtrar tareas');
    }
  }

  Future<Task> fetchTaskById(int id) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/task/$id'),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task.fromJson(data['task']);
    } else {
      throw Exception('Error al obtener la tarea');
    }
  }

  Future<bool> createTask({
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final token = await TokenService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/task'),
      headers: {'Authorization': '$token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
      }),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateTask({
    required int id,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final token = await TokenService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/task/$id'),
      headers: {'Authorization': '$token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
      }),
    );
    return response.statusCode == 201;
  }

  Future<void> deleteTask(int id) async {
    final token = await TokenService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/task/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
    );

    if (response.statusCode != 201) {
      throw Exception('No se pudo eliminar la tarea');
    }
  }

  Future<bool> completeTask(int id) async {
    final token = await TokenService.getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/task/$id/complete'),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 201) return true;
    return false;
  }
}
