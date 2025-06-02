import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/task/presentation/notifiers/task_viewmodel.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final green = Color(0xFF16961A);

  @override
  void initState() {
    super.initState();
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    taskVM.loadTaskById(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context);
    final task = taskVM.selectedTask;

    bool isOverdue() {
      if (task == null || task.completed) return false;
      return task.dueDate.isBefore(DateTime.now());
    }

    String formatDate(DateTime date) {
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Detalles de la tarea', style: TextStyle(color: green)),
        centerTitle: true,
      ),
      body:
          taskVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : task == null
              ? Center(
                child: Text(
                  'No se pudo cargar la tarea',
                  style: TextStyle(color: green),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: green,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            task.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Fecha límite: ${formatDate(task.dueDate)}',
                            style: const TextStyle(color: Color(0xFFDAAC16)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (task.completed)
                      Center(
                        child: Text(
                          'Tarea completada',
                          style: TextStyle(
                            color: green,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final success =
                              await Provider.of<TaskViewModel>(
                                context,
                                listen: false,
                              ).completeSelectedTask();

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tarea completada con éxito'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al completar la tarea'),
                              ),
                            );
                          }
                        },
                        child: Text(
                          isOverdue() ? 'Completar con retraso' : 'Completar',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
