import 'package:flutter/material.dart';
import 'package:produtos/_comum/my_snackbar.dart';
import 'package:produtos/model/user.dart';
import 'package:produtos/services/auth_service.dart';

import 'login_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      _authService
          .create(UserApp(username: username, email: email, password: password))
          .then((String? error) {
        if (error != null) {
          showSnackBar(context: context, message: error);
        } else {
          showSnackBar(
            context: context,
            message: "Cadastro feito com sucesso. Realize o login!",
            isError: false,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
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
                  child:
                      const Icon(Icons.person, size: 50, color: Colors.white),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Usuário',
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.cyan),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'É necessário preencher o campo';
                              }
                              if (value.length !=
                                  value.replaceAll(' ', '').length) {
                                return 'O campo de usuário não deve ter espaços';
                              }
                              if (value.length <= 2) {
                                return 'Usuário deve ter mais que dois caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: Icon(Icons.email, color: Colors.cyan),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'É necessário preencher o campo';
                              }
                              if (value.length !=
                                  value.replaceAll(' ', '').length) {
                                return 'O campo não deve ter espaços';
                              }
                              if (!value.contains('@')) {
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
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'É necessário preencher o campo';
                              }
                              if (value.length !=
                                  value.replaceAll(' ', '').length) {
                                return 'O campo não deve ter espaços';
                              }
                              if (value.length < 5) {
                                return 'A senha deve ser maior que 4 dígitos';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.cyan,
                              minimumSize: const Size(
                                  double.infinity, 50), // Botão full width
                            ),
                            child: const Text('Cadastrar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Link para a tela de login
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('Já tem uma conta? Faça login',
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
