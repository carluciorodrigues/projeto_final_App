import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:produtos/model/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection('products');

  Future<String?> create(Product product) async {
    try {
      DocumentReference docRef = await firebase.add(product.toMap());
      await docRef.update({'id': docRef.id});
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Stream<QuerySnapshot> allProducts(String username) {
    return firebase.where('username', isEqualTo: username).snapshots();
  }

  Future<String?> updateProduct(String? id, String name, int quantity) async {
    try {
      await firebase.doc(id).update({
        'nome': name,
        'quantidade': quantity,
      });

      return null;
    } on FirebaseException catch (e) {
      return "Erro ao atualizar o produto: ${e.message}";
    }
  }

  Future<void> deleteProduct(String? id) async {
    await firebase.doc(id).delete();
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
