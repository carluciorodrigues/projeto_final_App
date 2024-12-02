import 'package:flutter/material.dart';
import 'package:produtos/pages/user_profile.dart';
import 'product_list.dart';
import 'product_form.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal'),
        backgroundColor: Colors.cyan,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_box,
                        color: Colors.cyan), // Ícone para cadastrar
                    title: const Text('Adicionar Produtos'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductFormScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list,
                        color: Colors.cyan), // Ícone para listar
                    title: const Text('Listar Produtos'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_box_rounded,
                        color: Colors.cyan), // Ícone para cadastrar
                    title: const Text('Perfil'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
