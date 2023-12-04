import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> createUser(
      {required String emailUser,
      required String pwdUser,
      required String nameUser}) async {
    try {
      final credentials = await auth.createUserWithEmailAndPassword(
        email: emailUser,
        password: pwdUser,
      );

      // Enviar verificación de correo electrónico
      await credentials.user!.sendEmailVerification();

      var photoUrl = 'https://cdn-icons-png.flaticon.com/512/5087/5087509.png';

      // Guardar datos en Firestore
      await _firestore.collection('users').doc(credentials.user!.uid).set({
        'correo': emailUser,
        'contraseña': pwdUser,
        'nombre': nameUser,
        'metodo': 'Correo',
        'photo_url': photoUrl,
      });

      return true;
    } catch (e) {
      print('Error al registrar usuario: $e');
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

      if (userCredential.user!.emailVerified) {
        return userCredential;
      }
    } catch (e) {
      print("Error de autenticación con correo y contraseña: $e");
      return null;
    }
  }
}
