import 'package:firebase_auth/firebase_auth.dart';
import 'package:produtos/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> create(UserApp user) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      await userCredential.user!.updateDisplayName(user.username);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Conta já existe.";
      } else {
        return "Erro ao criar usuário: ${e.message}";
      }
    } catch (e) {
      return "Erro: ${e}";
    }
  }

  Future<String?> login(UserApp user) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      String? username = userCredential.user?.displayName;

      if (username != null) {
        await prefs.setString('username', username);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<UserApp?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return UserApp(
          id: user.uid, username: user.displayName, email: user.email);
    }

    return null;
  }
}
