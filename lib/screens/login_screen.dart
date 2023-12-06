import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        appBar: AppBar(
          title: Text(
            'Inicio de sesión',
            style: TextStyle(
              color: GlobalValues.flagTheme.value
                  ? Colors.white // Texto en modo oscuro
                  : Colors.white, // Texto en modo claro
            ),
          ),
          backgroundColor: GlobalValues.flagTheme.value
              ? Color.fromARGB(255, 34, 118, 254)
              : Color.fromARGB(255, 31, 166, 187),
          // Agrega más configuraciones de AppBar según tus necesidades
        ),
        body: Stack(
          children: [
            // Fondo con la imagen
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    GlobalValues.flagTheme.value
                        ? 'assets/images/FondoNegro.jpg'
                        : 'assets/images/Fondo.jpg',
                  ),
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
          color: GlobalValues.flagTheme.value
              ? Color.fromARGB(255, 254, 133, 34)
              : Color.fromARGB(255, 31, 166, 187),
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
            _buildFloatingActionButton(Icons.login, 'Iniciar Sesión', () {
              var email = txtConUser.text;
              var pass = txtConPass.text;
            }),
            Checkbox(
              value: GlobalValues.session.getBool('check') ?? false,
              activeColor: Colors.orange,
              onChanged: (bool? newBool) {
                setState(() {
                  GlobalValues.session.setBool('check', newBool ?? false);
                });
              },
            ),
            const Text("Guardar Sesión"),
            SignInButton(
              Buttons.google,
              text: "Inicia Sesión con Google",
              onPressed: () async {
                UserCredential? userCredential = await signInWithGoogle();

                if (userCredential?.user != null) {
                  // Verifica si el Checkbox está marcado
                  bool isCheckboxChecked =
                      GlobalValues.session.getBool('check') ?? false;

                  // Si el Checkbox está marcado, actualiza la sesión
                  if (isCheckboxChecked) {
                    setState(() {
                      GlobalValues.session.setBool('session', true);
                    });
                  }

                  Navigator.pushReplacementNamed(context, '/inicio');
                } else {
                  // Credenciales incorrectas, mostrar un showDialog
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
                }
              },
            ),
            SignInButton(
              Buttons.gitHub,
              text: 'Inicia Sesión con GitHub',
              onPressed: () async {
                _gitHubSignIn(context);
                if (isCheckboxChecked()) {}
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

      // Autenticar con Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Crear usuario en Firebase
      await createUserInFirebase(userCredential, 'google');

      return userCredential;
    } catch (error) {
      print("Error durante la autenticación con Google: $error");
      return showDialog(
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
    }
  }

  Future<void> createUserInFirebase(
      UserCredential userCredential, String loginMethod) async {
    try {
      // Obtener datos del usuario
      var user = userCredential.user;
      var email = user!.email;
      var photoUrl = user.photoURL;

      // Crear usuario en Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'correo': email,
        'metodo': loginMethod,
        'photo_url': photoUrl,
      });
    } catch (e) {
      print('Error al crear usuario en Firebase: $e');
      // Puedes manejar el error según tus necesidades
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
        try {
          // Verifica si el Checkbox está marcado
          bool isCheckboxChecked =
              GlobalValues.session.getBool('check') ?? false;

          // Si el Checkbox está marcado, actualiza la sesión
          if (isCheckboxChecked) {
            setState(() {
              GlobalValues.session.setBool('session', true);
            });
          }

          Navigator.pushReplacementNamed(context, '/inicio');
        } catch (error) {
          // Manejar errores de autenticación
          print("Error de autenticación: $error");
        }

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
        fillColor: GlobalValues.flagTheme.value
            ? Colors.black // Color del texto del label en modo oscuro
            : Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        alignLabelWithHint: true,
        labelStyle: TextStyle(
          color: GlobalValues.flagTheme.value
              ? Colors.white // Color del texto del label en modo oscuro
              : Colors.black, // Color del texto del label en modo claro
        ),
      ),
      style: TextStyle(
        color: GlobalValues.flagTheme.value
            ? Colors.white // Color del texto ingresado en modo oscuro
            : Colors.black, // Color del texto ingresado en modo claro
      ),
      controller: controller,
    );
  }

  bool isCheckboxChecked() {
    return GlobalValues.session.getBool('session') ?? false;
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
          // Verifica si el Checkbox está marcado
          bool isCheckboxChecked =
              GlobalValues.session.getBool('check') ?? false;

          // Si el Checkbox está marcado, actualiza la sesión
          if (isCheckboxChecked) {
            setState(() {
              GlobalValues.session.setBool('session', true);
            });
          }
          // Autenticación exitosa, redirigir a la pantalla de inicio
          Navigator.pushReplacementNamed(context, '/inicio');
        } else {
          // Credenciales incorrectas, mostrar un showDialog
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Credenciales incorrectas'),
                content:
                    const Text('Por favor, verifica tu correo, contraseña o .'),
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
}
