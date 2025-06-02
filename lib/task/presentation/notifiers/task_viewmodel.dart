import 'package:flutter/material.dart';
import 'package:tasky/task/data/models/task.dart';
import 'package:tasky/task/data/repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _service = TaskRepository();
  List<Task> tasks = [];
  Task? selectedTask;
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

  Future<void> loadTaskById(int id) async {
    isLoading = true;
    notifyListeners();

    selectedTask = await _service.fetchTaskById(id);

    isLoading = false;
    notifyListeners();
  }

  Future<bool> completeSelectedTask() async {
    if (selectedTask == null) return false;

    final success = await _service.completeTask(selectedTask!.id);
    if (success) {
      selectedTask = Task(
        id: selectedTask!.id,
        title: selectedTask!.title,
        description: selectedTask!.description,
        completed: true,
        dueDate: selectedTask!.dueDate,
      );
      notifyListeners();
    }
    return success;
  }

  void clearSelectedTask() {
    selectedTask = null;
    notifyListeners();
  }
}
