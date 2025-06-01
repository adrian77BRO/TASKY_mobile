import 'package:flutter/material.dart';
import 'package:tasky/task/data/models/task.dart';
import 'package:tasky/task/data/repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _service = TaskRepository();
  List<Task> tasks = [];
  bool isLoading = false;

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();

    tasks = await _service.fetchTasks();

    isLoading = false;
    notifyListeners();
  }

  Future<void> filterTasksByStatus(String status) async {
    isLoading = true;
    notifyListeners();

    tasks = await _service.fetchTasksByStatus(status);

    isLoading = false;
    notifyListeners();
  }
}
