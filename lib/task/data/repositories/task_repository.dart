import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasky/core/network/endpoints.dart';
import 'package:tasky/core/storage/token_service.dart';
import 'package:tasky/task/data/datasource/task_service.dart';
import 'package:tasky/task/data/models/task.dart';

class TaskApiRepository implements ITaskService {
  @override
  Future<List<Task>> fetchTasks() async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse(ApiEndpoints.tasks),
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

  @override
  Future<List<Task>> fetchTasksByStatus(String status) async {
    final token = await TokenService.getToken();
    final uri =
        status == 'all'
            ? Uri.parse(ApiEndpoints.tasks)
            : Uri.parse(ApiEndpoints.searchTasks(status));

    final response = await http.get(uri, headers: {'Authorization': '$token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List tasksJson = data['tasks'];
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error al filtrar tareas');
    }
  }

  @override
  Future<Task> fetchTaskById(int id) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse(ApiEndpoints.task(id)),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task.fromJson(data['task']);
    } else {
      throw Exception('Error al obtener la tarea');
    }
  }

  @override
  Future<bool> createTask({
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final token = await TokenService.getToken();
    final response = await http.post(
      Uri.parse(ApiEndpoints.tasks),
      headers: {'Authorization': '$token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
      }),
    );
    return response.statusCode == 201;
  }

  @override
  Future<bool> updateTask({
    required int id,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final token = await TokenService.getToken();
    final response = await http.put(
      Uri.parse(ApiEndpoints.task(id)),
      headers: {'Authorization': '$token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
      }),
    );
    return response.statusCode == 201;
  }

  @override
  Future<void> deleteTask(int id) async {
    final token = await TokenService.getToken();
    final response = await http.delete(
      Uri.parse(ApiEndpoints.task(id)),
      headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
    );

    if (response.statusCode != 201) {
      throw Exception('No se pudo eliminar la tarea');
    }
  }

  @override
  Future<bool> completeTask(int id) async {
    final token = await TokenService.getToken();
    final response = await http.patch(
      Uri.parse(ApiEndpoints.completeTask(id)),
      headers: {'Authorization': '$token'},
    );

    return response.statusCode == 201;
  }
}