import 'package:flutter/material.dart';
import 'package:produtos/model/user.dart';
import 'package:produtos/pages/product_list.dart';
import 'package:produtos/services/auth_service.dart';
import '../_comum/my_snackbar.dart';
import 'register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      String? error =
          await _authService.login(UserApp(email: email, password: password));

      if (error != null) {
        showSnackBar(context: context, message: error);
      } else {
        showSnackBar(
          context: context,
          message: "Login feito com sucesso!",
          isError: false,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(),
          ),
        );
      }
    } catch (e) {
      showSnackBar(context: context, message: "Unexpected error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone de usuário
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.cyan,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Card para o formulário
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'e-mail',
                            prefixIcon: Icon(Icons.email, color: Colors.cyan),
                          ),
                          validator: (String? email) {
                            if (email == null || email.isEmpty) {
                              return 'É necessário preencher o campo';
                            }
                            if (!email.contains('@')) {
                              return 'O campo deve ser um e-mail válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: Icon(Icons.lock, color: Colors.cyan),
                          ),
                          obscureText: true,
                          validator: (String? password) {
                            if (password == null || password.isEmpty) {
                              return "Preencha o campo de senha";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.cyan,
                            minimumSize: const Size(
                                double.infinity, 50), // Botão full width
                          ),
                          child: const Text('Entrar'),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Cadastre-se',
                      style: TextStyle(color: Colors.cyan)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
