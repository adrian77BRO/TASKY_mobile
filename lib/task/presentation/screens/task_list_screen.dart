import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/task/data/models/task.dart';
import 'package:tasky/task/presentation/notifiers/task_viewmodel.dart';

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
    final green = Colors.greenAccent.shade400;
    String selectedStatus = 'all';

    Color getStatusColor(Task task) {
      if (task.completed) return Colors.green;
      if (task.dueDate.isBefore(DateTime.now())) return Colors.red;
      return Colors.amber;
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
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
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
          // TODO: Agregar nueva tarea
        },
      ),
    );
  }
}
