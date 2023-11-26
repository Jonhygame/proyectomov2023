import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/firebase/email_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController txtConUser = TextEditingController();
  final TextEditingController txtConPass = TextEditingController();
  final EmailAuth emailAuth = EmailAuth();

  @override
  void initState() {
    super.initState();
    GlobalValues.flagTheme.value = GlobalValues.prefs.getBool('teme') ?? false;
    GlobalValues.flagTheme.value = GlobalValues.teme.getBool('teme') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con la imagen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Images/Fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido de la pantalla
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: _buildLoginContainer(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildLoginContainer() {
    return Container(
      height: 600,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 151, 26, 26),
      ),
      child: Column(
        children: [
          _buildTextField(txtConUser, 'Correo'),
          const SizedBox(height: 10),
          _buildTextField(txtConPass, 'Password'),
          const SizedBox(height: 10),
          _buildFloatingActionButton(Icons.bookmark_add, 'Register :)', () {
            Navigator.pushNamed(context, '/register');
          }),
          const SizedBox(height: 10),
          _buildFloatingActionButton(Icons.login, 'Send', () {
            var email = txtConUser.text;
            var pass = txtConPass.text;
            emailAuth.login(emailLogin: email, pwdLogin: pass);
            //Navigator.pushNamed(context, '/dash');
          }),
          _buildSessionCheckbox(),
          const Text("Guardar session"),
          SignInButton(
            Buttons.google,
            text: "Inicia Sesión con Google",
            onPressed: () async {
              UserCredential? userCredential = await signInWithGoogle();

              if (userCredential != null) {
                // El usuario ha iniciado sesión exitosamente
                print(
                    "Usuario autenticado: ${userCredential.user?.displayName}");
              } else {
                // Ocurrió un error durante la autenticación
                print("Error de autenticación con Google");
              }
            },
          ),
        ],
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      controller: controller,
    );
  }

  Widget _buildFloatingActionButton(
      IconData icon, String label, Function() onPressed) {
    return FloatingActionButton.extended(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
    );
  }

  Widget _buildSessionCheckbox() {
    return Checkbox(
      value: GlobalValues.session.getBool('session') ?? false,
      activeColor: Colors.orange,
      onChanged: (bool? newbool) {
        setState(() {
          GlobalValues.session.setBool('session', newbool!);
        });
      },
    );
  }
}
