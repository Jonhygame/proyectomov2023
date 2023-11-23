import 'package:flutter/material.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/firebase/email_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final emailAuth = EmailAuth();
    GlobalValues.flagTheme.value = GlobalValues.prefs.getBool('teme') ?? false;
    GlobalValues.flagTheme.value = GlobalValues.teme.getBool('teme') ?? false;
    TextEditingController txtConUser = TextEditingController();
    TextEditingController txtConPass = TextEditingController();

    final txtUser = TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text('Correo')),
      controller: txtConUser,
    );

    final txtPass = TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text('Password')),
      controller: txtConPass,
      obscureText: true,
    );

    final imgLogo = Container(
      width: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'http://2.bp.blogspot.com/-qVFkYqU-xJ8/TahMxxxxy9I/AAAAAAAAAB0/JRCcPDScQww/s1600/97-remeras-homero-simpson-350.jpg')),
      ),
    );

    final btnEntrar = FloatingActionButton.extended(
        icon: const Icon(Icons.login),
        label: const Text('Send'),
        onPressed: () {
          var email = txtConUser.text;
          var pass = txtConPass.text;
          emailAuth.login(emailLogin: email, pwdLogin: pass);
          //Navigator.pushNamed(context, '/dash');
        });

    final btnRegister = FloatingActionButton.extended(
        icon: const Icon(Icons.bookmark_add),
        label: const Text('Register :)'),
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        });

    final session = Checkbox(
        value: GlobalValues.session.getBool('session') ?? false,
        activeColor: Colors.orange,
        onChanged: (bool? newbool) {
          setState(() {
            GlobalValues.session.setBool('session', newbool!);
          });
        });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 398,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 151, 26, 26)),
                //color: Colors.blueGrey,
                child: Column(children: [
                  txtUser,
                  const SizedBox(height: 10),
                  txtPass,
                  const SizedBox(
                    height: 10,
                  ),
                  btnRegister,
                  const SizedBox(height: 10),
                  btnEntrar,
                  session,
                  const Text("Guardar session"),
                ]),
              ),
              //Container(padding: const EdgeInsets.only(bottom: 200), child: imgLogo)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
