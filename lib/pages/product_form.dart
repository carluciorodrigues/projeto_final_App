import 'package:flutter/material.dart';
import 'package:produtos/model/Product.dart';
import 'package:produtos/pages/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../_comum/my_snackbar.dart';
import '../services/product_service.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _productService = ProductService();

  void clearFields() {
    _nameController.clear();
    _quantityController.clear();
  }

  Future<void> _saveProduct() async {
    var productName = _nameController.text;
    int? quantity = int.parse(_quantityController.text);
    final prefs = await SharedPreferences.getInstance();

    String? username = prefs.getString('username');

    Product product =
        Product(name: productName, quantity: quantity, username: username);

    _productService.create(product).then((String? error) {
      if (error != null) {
        showSnackBar(context: context, message: error);
      } else {
        showSnackBar(
            context: context,
            message: "Cadastro feito com sucesso!",
            isError: false);

        clearFields();
      }
    });
  }

  void _redirect() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produtos'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100.0,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_business_rounded,
                    size: 100.0,
                  )
                ],
              ),
              const SizedBox(
                height: 100.0,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.label),
                        labelText: 'Nome do Produto',
                      ),
                      maxLength: 25,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'É necessário preencher o campo.';
                        }
                        if (value.length < 3) {
                          return 'O produto deve ter mais de dois caracteres.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.production_quantity_limits),
                        labelText: 'Quantidade do Produto',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: (String? value) {
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: clearFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      'Limpar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _redirect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      'Listar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
