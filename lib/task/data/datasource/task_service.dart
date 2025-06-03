import 'package:tasky/task/data/models/task.dart';

abstract class ITaskService {
  Future<List<Task>> fetchTasks();
  Future<List<Task>> fetchTasksByStatus(String status);
  Future<Task> fetchTaskById(int id);
  Future<bool> createTask({
    required String title,
    required String description,
    required DateTime dueDate,
  });
  Future<bool> updateTask({
    required int id,
    required String title,
    required String description,
    required DateTime dueDate,
  });
  Future<void> deleteTask(int id);
  Future<bool> completeTask(int id);
}
