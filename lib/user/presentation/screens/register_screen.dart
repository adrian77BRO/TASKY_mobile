import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/navigation/routes.dart';
import 'package:tasky/user/presentation/notifiers/user_notifier.dart';

class RegisterScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<UserViewModel>(context);
    final green = Color(0xFF16961A);

    void showMessage(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'TASKY',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: green,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Usuario', style: TextStyle(color: green)),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: green,
                  decoration: InputDecoration(
                    hintText: 'ejemplo',
                    hintStyle: TextStyle(color: green.withOpacity(0.6)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Correo electrónico',
                    style: TextStyle(color: green),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: green,
                  decoration: InputDecoration(
                    hintText: 'ejemplo@gmail.com',
                    hintStyle: TextStyle(color: green.withOpacity(0.6)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Contraseña', style: TextStyle(color: green)),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: green,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: green),
                      borderRadius: BorderRadius.circular(10),
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
                      authVM.isLoading
                          ? null
                          : () async {
                            final username = usernameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            if (username.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty) {
                              showMessage('Todos los campos son obligatorios');
                              return;
                            }

                            final message = await authVM.register(
                              username,
                              email,
                              password,
                            );
                            showMessage(message);

                            if (message.contains('exitosamente')) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.login,
                              );
                            }
                          },
                  child:
                      authVM.isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                            'Registrarme',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  child: Text(
                    '¿Ya tienes cuenta?',
                    style: TextStyle(color: green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
