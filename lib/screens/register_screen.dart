import 'package:flutter/material.dart';
import 'package:proyectomov2023/firebase/email_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final conName = TextEditingController();
  final conEmailUser = TextEditingController();
  final conPassUser = TextEditingController();
  final emailAuth = EmailAuth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 370,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 151, 26, 26)),
                //color: Colors.blueGrey,
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('Nombre')),
                    controller: conName,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('Email')),
                    controller: conEmailUser,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('Password')),
                    controller: conPassUser,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        var email = conEmailUser.text;
                        var pass = conPassUser.text;
                        emailAuth.createUser(emailUser: email, pwdUser: pass);
                      },
                      child: Text("Guardar")),
                ]), //Container(padding: const EdgeInsets.only(bottom: 200), child: imgLogo)
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
