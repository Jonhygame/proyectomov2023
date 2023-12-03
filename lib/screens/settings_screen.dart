import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/screens/dashboard_screen.dart';
import 'package:proyectomov2023/screens/inicio_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailResetController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registro'),
          backgroundColor: Color.fromARGB(255, 31, 166, 187),
        ),
        bottomNavigationBar: CurvedNavigationBar(
            height: 55,
            color: Colors.blueGrey.shade100,
            animationDuration: Duration(milliseconds: 600),
            backgroundColor: Colors.blueGrey,
            index: 2,
            onTap: (index) {
              switch (index) {
                case 0:
                  print('caso 0 ');
                  Future.delayed(Duration(milliseconds: 600), () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            InicioScreen(),
                        settings: RouteSettings(name: '/inicio'),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        }, // Establecer la duración a 0 para desactivar la transición
                      ),
                    );
                  });
                  break;
                case 1:
                  print('caso 1 ');
                  Future.delayed(Duration(milliseconds: 600), () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DashboardScreen(),
                        settings: RouteSettings(name: '/dashboard'),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    );
                  });
                  break;
                case 2:
                  print('caso 2 ');
                  //pantalla actual
                  break;
                default:
                  print('nada');
              }
            },
            items: [
              Icon(
                Icons.home,
                color: Colors.blueGrey,
              ),
              Icon(
                Icons.map,
                color: Colors.blueGrey,
              ),
              Icon(
                Icons.list,
                color: Colors.blueGrey,
              ),
            ]),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Fondo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: 300,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 31, 166, 187),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Text('Cambiar Tema'),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: DayNightSwitcher(
                          isDarkModeEnabled: GlobalValues.flagTheme.value,
                          onStateChanged: (isDarkModeEnabled) {
                            setState(() {
                              GlobalValues.teme
                                  .setBool('teme', isDarkModeEnabled);
                              GlobalValues.flagTheme.value = isDarkModeEnabled;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FloatingActionButton.extended(
                        backgroundColor: Colors.purple,
                        label: Text('Cambiar Contraseña'),
                        onPressed: () {
                          _showResetPasswordDialog(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      FloatingActionButton.extended(
                        icon: Icon(Icons.logout),
                        backgroundColor: Colors.red,
                        label: Text('Cerrar Sesión'),
                        onPressed: () async {
                          // Cerrar sesión de Google
                          await _handleSignOut();

                          setState(() {
                            GlobalValues.session.setBool('session', false);
                          });
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              const Text(
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

      return userCredential;
    } catch (error) {
      // ignore: use_build_context_synchronously
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

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print('Error al cerrar sesión de Google: $error');
      // Manejar el error según tus necesidades
    }
  }
}
