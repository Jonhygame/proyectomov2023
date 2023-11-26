import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<bool> createUser(
      {required String emailUser, required String pwdUser}) async {
    try {
      final credentials = await auth.createUserWithEmailAndPassword(
          email: emailUser, password: pwdUser);
      credentials.user!.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } catch (e) {
      print("Error de autenticación con correo y contraseña: $e");
      return null;
    }
  }
}
