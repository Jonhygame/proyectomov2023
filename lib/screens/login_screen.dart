import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController emailResetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    GlobalValues.flagTheme.value = GlobalValues.prefs.getBool('teme') ?? false;
    GlobalValues.flagTheme.value = GlobalValues.teme.getBool('teme') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Fondo con la imagen
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Fondo.jpg'),
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
      ),
    );
  }

  Widget _buildLoginContainer() {
    return SingleChildScrollView(
      child: Container(
        height: 600,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 31, 166, 187),
        ),
        child: Column(
          children: [
            // Mover el logo aquí para que aparezca encima de los TextField
            Image.asset(
              'assets/images/logoUsuario.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20), // Ajusta según tu preferencia
            _buildTextField(txtConUser, 'Correo'),
            const SizedBox(height: 10),
            _buildTextField(txtConPass, 'Password'),
            const SizedBox(height: 10),
            // Row para colocar los textos "Registrate aquí" y "¿Olvidaste tu contraseña?"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Registrate aquí',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    _showResetPasswordDialog(context);
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildFloatingActionButton(Icons.login, 'Send', () {
              var email = txtConUser.text;
              var pass = txtConPass.text;
            }),
            _buildSessionCheckbox(),
            const Text("Guardar session"),
            SignInButton(
              Buttons.google,
              text: "Inicia Sesión con Google",
              onPressed: () async {
                UserCredential? userCredential = await signInWithGoogle();

                if (userCredential != null) {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Un error ha ocurrido'),
                        content: Text('Error de autenticación con Google'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.black, // Cambia el color a negro
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.pushNamed(context, '/inicio');
                  // Credenciales incorrectas, mostrar un showDialog
                  // ignore: use_build_context_synchronously
                }
              },
            ),
            SignInButton(
              Buttons.gitHub,
              text: 'GitHub Connection',
              onPressed: () async {
                _gitHubSignIn(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (error) {
      print("Error durante la autenticación con Google: $error");
      return null;
    }
  }

  final GitHubSignIn gitHubSignIn = GitHubSignIn(
    clientId: '42b7e29d1de8fc9d1278',
    clientSecret: '7139ca8a8a3235ddf725da8d14f294ecb61c8d80',
    redirectUrl: 'https://proyectopmsn2023.firebaseapp.com/__/auth/handler',
    title: 'GitHub Connection',
    centerTitle: false,
  );

  void _gitHubSignIn(BuildContext context) async {
    var result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        Navigator.pushNamed(context, '/inicio');
        break;

      case GitHubSignInResultStatus.cancelled:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Un error ha ocurrido'),
              content: Text('Error de autenticación con GitHub'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.black, // Cambia el color a negro
                    ),
                  ),
                ),
              ],
            );
          },
        );
        break;
      case GitHubSignInResultStatus.failed:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Un error ha ocurrido'),
              content: Text('Error de autenticación con GitHub'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.black, // Cambia el color a negro
                    ),
                  ),
                ),
              ],
            );
          },
        );
        break;
    }
  }

  void _showResetPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restablecer contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ingresa tu dirección de correo electrónico para restablecer la contraseña:',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                emailResetController,
                'Correo',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Cerrar el cuadro de diálogo
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                // Lógica para enviar el correo de restablecimiento de contraseña
                _sendPasswordResetEmail(emailResetController.text);
                // Cerrar el cuadro de diálogo
                Navigator.pop(context);
              },
              child: const Text(
                'Enviar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  // Función para enviar el correo de restablecimiento de contraseña
  void _sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Muestra un mensaje al usuario informando que se envió el correo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Restablecimiento de contraseña'),
            content: Text(
              'Se ha enviado un correo electrónico para restablecer tu contraseña. Por favor, verifica tu bandeja de entrada.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error al enviar el correo de restablecimiento de contraseña: $e');
      // Muestra un mensaje de error al usuario
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'Ocurrió un error al intentar restablecer la contraseña. Por favor, inténtalo de nuevo.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        alignLabelWithHint:
            true, // Alinea el texto del placeholder con el texto ingresado
      ),
      controller: controller,
    );
  }

  Widget _buildFloatingActionButton(
      IconData icon, String label, Function() onPressed) {
    return FloatingActionButton.extended(
      icon: Icon(icon),
      label: Text(label),
      onPressed: () async {
        var email = txtConUser.text;
        var pass = txtConPass.text;

        UserCredential? userCredential =
            await emailAuth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );

        if (userCredential != null) {
          // Autenticación exitosa, redirigir a la pantalla de inicio
          Navigator.pushNamed(context, '/inicio');
        } else {
          // Credenciales incorrectas, mostrar un showDialog
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Credenciales incorrectas'),
                content: Text('Por favor, verifica tu correo y contraseña.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black, // Cambia el color a negro
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
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
