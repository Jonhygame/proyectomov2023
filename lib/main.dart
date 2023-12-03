import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/assets/styles_app.dart';
import 'package:proyectomov2023/routes.dart';
import 'package:proyectomov2023/screens/inicio_screen.dart';
import 'package:proyectomov2023/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalValues.configPrefs();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalValues.flagTheme.value = GlobalValues.teme.getBool('teme') ?? false;

    return ValueListenableBuilder(
      valueListenable: GlobalValues.flagTheme,
      builder: (context, value, _) {
        // Verificar si la casilla de verificación está activada
        bool isSessionActive = GlobalValues.session.getBool('session') ?? false;

        // Redirigir a la pantalla correspondiente
        Widget initialScreen =
            isSessionActive ? const InicioScreen() : const LoginScreen();

        return MaterialApp(
          home: initialScreen,
          routes: getRoutes(),
          theme: value
              ? StylesApp.darkTheme(context)
              : StylesApp.lightTheme(context),
        );
      },
    );
  }
}
