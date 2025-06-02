import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky/task/data/models/task.dart';
import 'package:tasky/task/data/repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _service = TaskRepository();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  DateTime? selectedDate;

  List<Task> tasks = [];
  Task? selectedTask;
  bool isLoading = false;

  String get formattedDate =>
      selectedDate != null
          ? DateFormat('dd-MM-yyyy').format(selectedDate!)
          : '';

  void pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(primary: Colors.greenAccent.shade400),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

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

  Future<bool> submitTask(BuildContext context) async {
    final title = titleController.text.trim();
    final desc = descController.text.trim();
    if (title.isEmpty || desc.isEmpty || selectedDate == null) return false;

    isLoading = true;
    notifyListeners();

    final success = await _service.createTask(
      title: title,
      description: desc,
      dueDate: selectedDate!,
    );

    isLoading = false;
    notifyListeners();
    return success;
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

  void disposeFields() {
    titleController.dispose();
    descController.dispose();
  }

  void clearSelectedTask() {
    selectedTask = null;
    notifyListeners();
  }
}
