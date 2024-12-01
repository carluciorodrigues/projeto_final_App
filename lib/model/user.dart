class UserApp {
  String? id;
  String? username;
  String? email;
  String? password;
  String? avatar;

  UserApp(
      {String? id,
      String? username,
      String? email,
      String? password,
      String? avatar})
      : this.id = id,
        this.username = username,
        this.email = email,
        this.password = password,
        this.avatar = avatar ??
            'https://www.pngarts.com/files/11/Avatar-Free-PNG-Image.png';

  factory UserApp.fromMap(Map<String, dynamic> map) {
    return UserApp(
        id: map['id'],
        username: map['username'],
        email: map['email'],
        password: map['password']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password
    };
  }
}
