import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/task/presentation/notifiers/task_notifier.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formVM = Provider.of<TaskViewModel>(context);
    final green = Color(0xFF16961A);
    final isEditing = formVM.editingTask != null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar tarea' : 'Nueva tarea', style: TextStyle(color: green)),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            child: Column(
              children: [
                _buildLabel('Título', green),
                const SizedBox(height: 4),
                TextField(
                  controller: formVM.titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('ejemplo_titulo', green),
                ),
                const SizedBox(height: 20),

                _buildLabel('Descripción', green),
                const SizedBox(height: 4),
                TextField(
                  controller: formVM.descController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: _inputDecoration('ejemplo_descripcion', green),
                ),
                const SizedBox(height: 20),

                _buildLabel('Fecha límite', green),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => formVM.pickDate(context),
                  child: InputDecorator(
                    decoration: _inputDecoration('dd-mm-aaaa', green),
                    child: Text(
                      formVM.formattedDate,
                      style: TextStyle(
                        color:
                            formVM.selectedDate == null
                                ? green.withOpacity(0.5)
                                : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                      formVM.isLoading
                          ? null
                          : () async {
                            final success = await formVM.submitTask(context);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tarea creada correctamente'),
                                ),
                              );
                              Navigator.pop(context);
                              Provider.of<TaskViewModel>(context, listen: false).clearForm();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Completa todos los campos'),
                                ),
                              );
                            }
                          },
                  child:
                      formVM.isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                            'Guardar',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(color: color, fontSize: 16)),
    );
  }

  InputDecoration _inputDecoration(String hint, Color color) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: color.withOpacity(0.5)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
