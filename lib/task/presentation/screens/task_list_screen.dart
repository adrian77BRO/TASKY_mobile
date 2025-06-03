import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/navigation/routes.dart';
import 'package:tasky/task/data/models/task.dart';
import 'package:tasky/task/presentation/notifiers/task_notifier.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskViewModel>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context);
    final green = Color(0xFF16961A);
    String selectedStatus = 'all';

    Color getStatusColor(Task task) {
      if (task.completed) return Color(0xFF16961A);
      if (task.dueDate.isBefore(DateTime.now())) return Color(0xFFDB1313);
      return Color(0xFFDAAC16);
    }

    String getStatusLabel(Task task) {
      if (task.completed) return 'Completado';
      if (task.dueDate.isBefore(DateTime.now())) return 'Retraso';
      return 'Pendiente';
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Tus tareas', style: TextStyle(color: green)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedStatus,
              dropdownColor: Colors.grey[900],
              style: TextStyle(color: green),
              decoration: InputDecoration(
                labelText: 'Filtrar por estado',
                labelStyle: TextStyle(color: green),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: green),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: green),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Todos')),
                DropdownMenuItem(value: 'pending', child: Text('Pendiente')),
                DropdownMenuItem(value: 'completed', child: Text('Completado')),
                DropdownMenuItem(value: 'overdue', child: Text('Retraso')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedStatus = value);
                  Provider.of<TaskViewModel>(
                    context,
                    listen: false,
                  ).filterTasksByStatus(value);
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.tasks.isEmpty
                      ? Center(
                        child: Text(
                          'No hay tareas disponibles',
                          style: TextStyle(color: green),
                        ),
                      )
                      : ListView.builder(
                        itemCount: vm.tasks.length,
                        itemBuilder: (_, i) {
                          final task = vm.tasks[i];
                          final color = getStatusColor(task);
                          final label = getStatusLabel(task);

                          return Card(
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.taskDetail,
                                  arguments: task.id,
                                ).then((_) {
                                  Provider.of<TaskViewModel>(
                                    context,
                                    listen: false,
                                  ).filterTasksByStatus(selectedStatus);
                                });
                              },
                              title: Text(
                                task.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                label,
                                style: TextStyle(color: color),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      final vm = Provider.of<TaskViewModel>(
                                        context,
                                        listen: false,
                                      );
                                      vm.loadTaskForEditing(task);

                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.taskForm,
                                      ).then((_) {
                                        Provider.of<TaskViewModel>(
                                          context,
                                          listen: false,
                                        ).filterTasksByStatus(selectedStatus);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFF1422BD),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              backgroundColor: Colors.black,
                                              title: const Text(
                                                'Confirmar eliminación',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              content: const Text(
                                                '¿Estás seguro de eliminar esta tarea?',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text(
                                                    'Cancelar',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text(
                                                    'Eliminar',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (confirm == true) {
                                        await Provider.of<TaskViewModel>(
                                          context,
                                          listen: false,
                                        ).deleteTask(task.id);
                                        Provider.of<TaskViewModel>(
                                          context,
                                          listen: false,
                                        ).filterTasksByStatus(selectedStatus);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color(0xFFDB1313),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: green,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          final formVM = Provider.of<TaskViewModel>(context, listen: false);
          formVM.clearForm();

          Navigator.pushNamed(context, AppRoutes.taskForm).then((_) {
            Provider.of<TaskViewModel>(
              context,
              listen: false,
            ).filterTasksByStatus(selectedStatus);
          });
        },
      ),
    );
  }
}
