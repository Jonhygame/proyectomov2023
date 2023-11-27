import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<bool> checkIfUserExists(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('users')
          .where('correo', isEqualTo: email)
          .get();

      print('Esto es lo que arrojó' + query.toString());

      if (query != null) {
        return true;
      } else {
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
              checkIfUserExists: checkIfUserExists,
            ),
          ],
        ),
      ),
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

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({required this.conPassUser});

  final TextEditingController conPassUser;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      controller: conPassUser,
      obscureText: true,
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    required this.conEmailUser,
    required this.conPassUser,
    required this.emailAuth,
    required this.checkIfUserExists,
  });

  final TextEditingController conEmailUser;
  final TextEditingController conPassUser;
  final EmailAuth emailAuth;
  final Future<bool> Function(String) checkIfUserExists;

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.email,
      onPressed: () async {
        var email = conEmailUser.text;
        var pass = conPassUser.text;

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
          // Llamada a la función para crear el usuario
          await emailAuth.createUser(emailUser: email, pwdUser: pass);

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
      },
      text: 'Registra tu correo',
    );
  }
}
