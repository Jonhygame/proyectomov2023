import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/assets/theme_provider.dart';
import 'package:proyectomov2023/screens/dashboard_screen.dart';
import 'package:proyectomov2023/screens/inicio_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:proyectomov2023/services/select_image.dart';
import 'package:proyectomov2023/services/upload_image.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailResetController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late String userId; // Agrega esta línea para definir userId
  File? imagen_to_upload;
  // Obtén el ThemeProvider del contexto

  @override
  void initState() {
    super.initState();
    // Obtener la identificación del usuario al inicializar el widget
    getUserId();
  }

  Future<void> getUserId() async {
    var user = _auth.currentUser;
    userId = user?.uid ??
        ''; // Puedes establecer un valor predeterminado o manejarlo según tus necesidades
  }

  @override
  Widget build(BuildContext context) {
    var user = _auth.currentUser;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Ajustes',
            style: TextStyle(
              color: GlobalValues.flagTheme.value
                  ? Colors.white // Texto en modo oscuro
                  : Colors.white, // Texto en modo claro
            ),
          ),
          backgroundColor: GlobalValues.flagTheme.value
              ? Color.fromARGB(255, 34, 118, 254)
              : Color.fromARGB(255, 31, 166, 187),
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            InicioScreen(),
                        settings: RouteSettings(name: '/inicio'),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                      (route) => false,
                    );
                  });
                  break;
                case 1:
                  print('caso 1 ');
                  Future.delayed(Duration(milliseconds: 600), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DashboardScreen(),
                        settings: RouteSettings(name: '/dashboard'),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                        transitionDuration: Duration(milliseconds: 0),
                      ),
                      (route) => false,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
            ),
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
            SingleChildScrollView(
              child: Container(
                height: 500,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GlobalValues.flagTheme.value
                      ? Color.fromARGB(255, 254, 133, 34)
                      : Color.fromARGB(255, 31, 166, 187),
                ),
                child: Center(
                  child: Column(
                    children: [
                      imagen_to_upload != null
                          ? _buildUserImageWidget(imagen_to_upload)
                          : _buildUserInfo(),
                      const Text(
                        'Cambiar Tema',
                        style: TextStyle(color: Colors.white),
                      ),
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
                      FutureBuilder<bool>(
                        future: _checkUserMethod(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            bool isUserMethodCorreo = snapshot.data ?? false;
                            // Mostrar el botón solo si el método es 'Correo'
                            return isUserMethodCorreo
                                ? FloatingActionButton.extended(
                                    backgroundColor: Colors.white,
                                    label: Text(
                                      'Cambiar Imagen',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      final XFile? imagen = await getImage();
                                      setState(() {
                                        imagen_to_upload = File(imagen!.path);
                                      });
                                      if (imagen_to_upload == null) {
                                        return;
                                      }
                                      final updloaded =
                                          await uploadImage(imagen_to_upload!);

                                      String? newPhotoUrl =
                                          await uploadImage(imagen_to_upload!);

                                      if (newPhotoUrl != null) {
                                        imagen_to_upload = null;
                                        // Actualizar la URL de la foto en Firestore
                                        await updatePhotoUrl(
                                            user?.uid, newPhotoUrl);

                                        setState(() {
                                          // Actualizar la UI con la nueva foto
                                        });
                                      }
                                    },
                                  )
                                : Container(); // Ocultar el botón si el método no es 'Correo'
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
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
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) =>
                                false, // Elimina todas las rutas anteriores
                          );
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

  Widget _buildUserImageWidget(File? imageFile) {
    var user = _auth.currentUser;
    var displayName = user?.displayName;
    var email = user?.email;
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: OctoImage.fromSet(
            image: FileImage(imageFile!),
            octoSet: OctoSet.circleAvatar(
              backgroundColor: Colors.transparent,
              text: Text(
                'Your Text',
              ),
            ),
          ),
        ),
        const SizedBox(
            height:
                8), // Ajusta el espacio entre la imagen y el texto según tus necesidades
        Text(
          displayName ?? email ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    var user = _auth.currentUser;
    var displayName = user?.displayName;
    var email = user?.email;

    // Obtener la URL de la foto del usuario desde Firestore
    Future<String?> getUserPhotoUrl() async {
      String? photoUrl;
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .get();

        if (snapshot.exists) {
          var userData = snapshot.data() as Map<String, dynamic>;
          photoUrl = userData['photo_url'];
        }
      } catch (e) {
        print('Error al obtener la URL de la foto del usuario: $e');
      }
      return photoUrl;
    }

    return FutureBuilder<String?>(
      future: getUserPhotoUrl(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var photoUrl = snapshot.data ?? user?.photoURL;

          return Column(
            children: [
              SizedBox(
                height: 100,
                child: OctoImage.fromSet(
                  image: NetworkImage(photoUrl ?? ''),
                  octoSet: OctoSet.circleAvatar(
                    backgroundColor: Colors.transparent,
                    text: Text(
                      displayName?.isNotEmpty == true
                          ? displayName![0]
                          : email?.isNotEmpty == true
                              ? email![0]
                              : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                displayName ?? email ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        } else {
          // Puedes mostrar un indicador de carga mientras se recupera la URL de la foto
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> updatePhotoUrl(String? userId, String photoUrl) async {
    try {
      // Referencia al documento del usuario en Firestore
      DocumentReference userReference =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Actualizar el campo 'photo_url' con la nueva URL
      await userReference.update({'photo_url': photoUrl});
    } catch (e) {
      print('Error al actualizar la URL de la foto en Firestore: $e');
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

  Future<bool> _checkUserMethod() async {
    var user = _auth.currentUser;
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        var userMethod = userData['metodo'];
        return userMethod == 'Correo';
      }
    } catch (e) {
      print('Error al verificar el método del usuario: $e');
    }
    return false; // Valor predeterminado si hay un error
  }
}
