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

  Future<bool> login(
      {required String emailLogin, required String pwdLogin}) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(
          email: emailLogin, password: pwdLogin);
      print(credentials.user!.emailVerified.toString());
      return true;
    } catch (e) {
      return false;
    }
  }
}
