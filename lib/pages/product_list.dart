import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:produtos/_comum/my_snackbar.dart';
import 'package:produtos/model/Product.dart';
import 'package:produtos/pages/product_form.dart';
import 'package:produtos/pages/user_profile.dart';
import 'package:produtos/services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lista de Compras'),
            SizedBox(width: 10),
            Icon(Icons.shopping_cart, color: Colors.white),
          ],
        ),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder(
        future: _productService.getUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final username = snapshot.data;

          if (username == null) {
            return const Center(child: Text('Usuário não encontrado.'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: _productService.allProducts(username),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhum produto encontrado!'));
              }

              final products = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final productData =
                      products[index].data() as Map<String, dynamic>;

                  Product product = Product.fromMap(productData);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              Text('Quantidade: ${product.quantity}'),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _openEditModal(context, product);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _productService.deleteProduct(product.id);
                                  showSnackBar(
                                    context: context,
                                    message: "Produto deletado com sucesso!",
                                    isError: false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
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
                    leading: const Icon(Icons.add_box, color: Colors.cyan),
                    title: const Text('Adicionar Produtos'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductFormScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list, color: Colors.cyan),
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
                        color: Colors.cyan),
                    title: const Text('Perfil'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserProfileScreen()),
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

  void _openEditModal(BuildContext context, Product product) {
    final TextEditingController nameController =
        TextEditingController(text: product.name);
    final TextEditingController priceController =
        TextEditingController(text: product.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Produto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String updatedName = nameController.text;
                final int? updatedQuantity = int.tryParse(priceController.text);

                if (updatedQuantity != null) {
                  await _productService
                      .updateProduct(product.id, updatedName, updatedQuantity)
                      .then((String? error) {
                    if (error != null) {
                      showSnackBar(context: context, message: error);
                    } else {
                      showSnackBar(
                        context: context,
                        message: "Alterações realizadas com sucesso!",
                        isError: false,
                      );
                      Navigator.of(context).pop();
                    }
                  });
                } else {
                  showSnackBar(
                    context: context,
                    message: 'Erro: A quantidade deve ser um número.',
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
