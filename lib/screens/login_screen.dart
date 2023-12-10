import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/firebase/email_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                color: GlobalValues.flagTheme.value
                    ? Colors.white // Texto en modo oscuro
                    : Colors.white, // Texto en modo claro
              ),
            ),
          ),
          backgroundColor: GlobalValues.flagTheme.value
              ? Color.fromARGB(255, 34, 118, 254)
              : Color.fromARGB(255, 31, 166, 187),
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
                    style: GoogleFonts.assistant(
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
                    style: GoogleFonts.assistant(
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
            Text(
              "Guardar Sesión",
              style: GoogleFonts.assistant(
                color: Colors.white,
              ),
            ),
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
                        title: Text(
                          'Un error ha ocurrido',
                          style: GoogleFonts.comicNeue(color: Colors.white),
                        ),
                        content: Text(
                          'Error de autenticación con Google',
                          style: GoogleFonts.comicNeue(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'OK',
                              style: GoogleFonts.paprika(
                                color: GlobalValues.flagTheme.value
                                    ? Colors.white
                                    : Colors.black,
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
            SignInButton(
              Buttons.facebook,
              text: 'Inicia Sesión con Facebook',
              onPressed: () {
                signInWithFacebook();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Nueva función para el inicio de sesión con Facebook
  Future<void> signInWithFacebook() async {
    try {
      // Verifica si ya hay una sesión activa
      //if (FirebaseAuth.instance.currentUser != null) {
      // Usuario ya autenticado, obtén el correo electrónico
      //String email = FirebaseAuth.instance.currentUser!.email!;

      // Puedes hacer algo con el correo electrónico, por ejemplo, imprimirlo
      //print('Correo electrónico del usuario: $email');

      // Aquí puedes realizar otras acciones según tu lógica
      // ...

      // Redirige a la pantalla de inicio
      Navigator.pushReplacementNamed(context, '/inicio');

      //}

      // Realiza la autenticación con Facebook
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Verifica si la autenticación fue exitosa
      if (loginResult.status == LoginStatus.success) {
        // Obtiene el token de acceso
        final AccessToken accessToken = loginResult.accessToken!;

        // Autenticar en Firebase con Facebook
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Crear usuario en Firebase (si no existe)
        await createUserInFirebase(userCredential, 'Facebook');

        // Verifica si el Checkbox está marcado
        bool isCheckboxChecked = GlobalValues.session.getBool('check') ?? false;

        // Si el Checkbox está marcado, actualiza la sesión
        if (isCheckboxChecked) {
          setState(() {
            GlobalValues.session.setBool('session', true);
          });
        }

        // Redirige a la pantalla de inicio
        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        // Muestra un mensaje de error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de autenticación'),
              content: Text(
                  'Ocurrió un error durante la autenticación con Facebook.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error durante la autenticación con Facebook: $e');
    }
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
      UserCredential? userCredential, String loginMethod) async {
    try {
      // Verifica si userCredential es nulo
      if (userCredential == null || userCredential.user == null) {
        print('Error: userCredential o user nulos.');
        return;
      }

      // Obtener datos del usuario
      var user = userCredential.user!;
      var email = user.email;
      var photoUrl = user.photoURL;

      // Verifica si email es nulo
      if (email == null) {
        print('Error: email nulo.');
        return;
      }

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
          String githubToken = result.token ?? "";
          // Autenticar en Firebase con GitHub
          AuthCredential credential =
              GithubAuthProvider.credential(githubToken);
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);

          // Crear usuario en Firebase (si no existe)
          await createUserInFirebase(userCredential, 'GitHub');

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
        } catch (e) {
          print("Error durante la autenticación con GitHub en Firebase: $e");
          // Trata el error según tus necesidades
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
          title: Text(
            'Restablecer contraseña',
            style: GoogleFonts.actor(
                color:
                    GlobalValues.flagTheme.value ? Colors.white : Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ingresa tu dirección de correo electrónico para restablecer la contraseña:',
                style: GoogleFonts.actor(
                    color: GlobalValues.flagTheme.value
                        ? Colors.white
                        : Colors.black),
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
              child: Text(
                'Cancelar',
                style: GoogleFonts.adventPro(
                    color: GlobalValues.flagTheme.value
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                // Lógica para enviar el correo de restablecimiento de contraseña
                _sendPasswordResetEmail(emailResetController.text);
                // Cerrar el cuadro de diálogo
                Navigator.pop(context);
              },
              child: Text(
                'Enviar',
                style: GoogleFonts.adventPro(
                    color: GlobalValues.flagTheme.value
                        ? Colors.white
                        : Colors.black),
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
