import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/firebase/email_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final conName = TextEditingController();
  final conEmailUser = TextEditingController();
  final conPassUser = TextEditingController();
  final emailAuth = EmailAuth();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkIfUserExists(String email) async {
    try {
      // Convertir el correo electrónico a minúsculas
      String lowercaseEmail = email.toLowerCase();

      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('users')
          .where('correo', isEqualTo: lowercaseEmail)
          .get();

      // Verifica si la consulta contiene documentos
      if (query.docs.isNotEmpty) {
        print('Usuario encontrado con el correo: $email');
        return true;
      } else {
        print('Usuario no encontrado con el correo: $email');
        return false;
      }
    } catch (e) {
      print('Error al verificar la existencia del usuario: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registro'),
          backgroundColor: Color.fromARGB(255, 31, 166, 187),
        ),
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: RegisterForm(
                  conName: conName,
                  conEmailUser: conEmailUser,
                  conPassUser: conPassUser,
                  emailAuth: emailAuth,
                  checkIfUserExists: checkIfUserExists,
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    required this.conName,
    required this.conEmailUser,
    required this.conPassUser,
    required this.emailAuth,
    required this.checkIfUserExists,
  });

  final TextEditingController conName;
  final TextEditingController conEmailUser;
  final TextEditingController conPassUser;
  final EmailAuth emailAuth;
  final Future<bool> Function(String) checkIfUserExists;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 31, 166, 187),
        ),
        child: Column(
          children: [
            LogoImage(),
            const SizedBox(height: 20),
            NameTextField(conName: conName),
            const SizedBox(height: 10),
            EmailTextField(conEmailUser: conEmailUser),
            const SizedBox(height: 10),
            PasswordTextField(conPassUser: conPassUser),
            const SizedBox(height: 10),
            RegisterButton(
              conEmailUser: conEmailUser,
              conPassUser: conPassUser,
              emailAuth: emailAuth,
              conNameUser: conName,
              checkIfUserExists: checkIfUserExists,
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({required this.conPassUser});

  final TextEditingController conPassUser;

  bool isPasswordValid(String password) {
    if (password.length < 6) {
      return false;
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      controller: conPassUser,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa una contraseña';
        }

        if (!isPasswordValid(value)) {
          return 'La contraseña debe tener al menos 6 caracteres, incluyendo al menos 1 mayúscula, 1 minúscula y 1 número';
        }

        return null;
      },
    );
  }
}

class LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logoUsuario.png',
      width: 100,
      height: 100,
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({required this.conName});

  final TextEditingController conName;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Nombre',
        filled: true,
        fillColor: Colors.white,
      ),
      controller: conName,
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({required this.conEmailUser});

  final TextEditingController conEmailUser;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
        filled: true,
        fillColor: Colors.white,
      ),
      controller: conEmailUser,
    );
  }
}

class RegisterButton extends StatelessWidget {
  RegisterButton({
    required this.conEmailUser,
    required this.conPassUser,
    required this.conNameUser,
    required this.emailAuth,
    required this.checkIfUserExists,
  });

  final TextEditingController conEmailUser;
  final TextEditingController conPassUser;
  final TextEditingController conNameUser;
  final EmailAuth emailAuth;
  final Future<bool> Function(String) checkIfUserExists;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.email,
      onPressed: () async {
        var email = conEmailUser.text;
        var pass = conPassUser.text;
        var name = conNameUser.text;

        // Validar si el usuario ya existe
        bool userExists = await checkIfUserExists(email);
        print(userExists);

        if (userExists) {
          // Mostrar el diálogo indicando que el usuario ya está registrado
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Usuario no registrado'),
                content: Text(
                  'El usuario con el correo $email ya está registrado. Si olvidaste tu contraseña, puedes restablecerla desde el menú de inicio.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Cerrar el diálogo
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
        } else {
          // Validar el formato del correo electrónico
          if (!isEmailValid(email)) {
            // Mostrar el diálogo indicando que el correo electrónico no es válido
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Correo electrónico no válido'),
                  content: Text(
                    'Por favor, ingresa un correo electrónico válido.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Cerrar el diálogo
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
          } else if (!isPasswordValid(pass)) {
            // Validar la contraseña
            // Mostrar el diálogo indicando que la contraseña no es válida
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Contraseña no válida'),
                  content: Text(
                    'La contraseña debe tener al menos 6 caracteres, incluyendo al menos 1 mayúscula, 1 minúscula y 1 número.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Cerrar el diálogo
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
          } else {
            // Llamada a la función para crear el usuario
            await emailAuth.createUser(
                emailUser: email, pwdUser: pass, nameUser: name);

            // Mostrar el diálogo indicando al usuario que revise su correo
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Verifica tu correo'),
                  content: Text(
                    'Hemos enviado un correo de verificación a $email. Por favor, revisa tu bandeja de entrada y sigue las instrucciones para completar tu registro.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Cerrar el diálogo
                        Navigator.pop(context);

                        // Cerrar la pantalla actual y mover al usuario al LoginScreen
                        Navigator.popAndPushNamed(context, '/login');
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
      },
      text: 'Registra tu correo',
    );
  }
}

bool isEmailValid(String email) {
  // Utiliza una expresión regular para validar el formato del correo electrónico
  return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
      .hasMatch(email);
}

bool isPasswordValid(String password) {
  if (password.length < 6) {
    return false;
  }

  if (!password.contains(RegExp(r'[A-Z]'))) {
    return false;
  }

  if (!password.contains(RegExp(r'[a-z]'))) {
    return false;
  }

  if (!password.contains(RegExp(r'[0-9]'))) {
    return false;
  }

  return true;
}
