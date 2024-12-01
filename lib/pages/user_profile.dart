import 'package:flutter/material.dart';
import 'package:produtos/model/user.dart';
import 'package:produtos/services/auth_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _authService = AuthService();

  late String _username = "";
  late String _email = "";

  @override
  void initState() {
    super.initState();
    _infoUser();
  }

  Future<void> _infoUser() async {
    UserApp? userInfo = await _authService.getUserData();

    if (userInfo != null) {
      setState(() {
        _email = userInfo.email!;
        _username = userInfo.username!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Informações do usuário",
            style: TextStyle(fontSize: 22)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.cyan),
                    title: Text(
                      _username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.cyan),
                    title: Text(
                      _email,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
