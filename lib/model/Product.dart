class Product {
  String? id;
  late String? username;
  late String name;
  late int quantity;

  Product(
      {String? id,
      String? username,
      required String name,
      required int quantity}) {
    this.id = id;
    this.username = username;
    this.name = name;
    this.quantity = quantity;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'],
        username: map['username'],
        name: map['nome'],
        quantity: map['quantidade']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'nome': name,
      'quantidade': quantity
    };
  }
}
