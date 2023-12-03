import 'package:flutter/material.dart';
import 'package:proyectomov2023/screens/add_Equipos.dart';
import 'package:proyectomov2023/screens/add_laboratorios.dart';
import 'package:proyectomov2023/screens/dashboard_screen.dart';
import 'package:proyectomov2023/screens/inicio_screen.dart';
import 'package:proyectomov2023/screens/listarEquipos_screen.dart';
import 'package:proyectomov2023/screens/login_screen.dart';
import 'package:proyectomov2023/screens/register_screen.dart';
import 'package:proyectomov2023/screens/selectdispositivo_screen.dart';
import 'package:proyectomov2023/screens/settings_screen.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    '/dashboard': (BuildContext context) => const DashboardScreen(),
    '/inicio': (BuildContext context) => const InicioScreen(),
    '/settings': (BuildContext context) => const SettingsScreen(),
    '/addLab': (BuildContext context) => AddLaboratorio(),
    '/register': (BuildContext context) => const RegisterScreen(),
    '/listarEquipos': (BuildContext context) => const ListarEquipoScreen(),
    '/addEquipo': (BuildContext context) => addEquipo(),
    '/login': (BuildContext context) => const LoginScreen(),
<<<<<<< HEAD
    '/selectDisp': (BuildContext context) => const SelectDispositivoScreen(),
    '/add': (BuildContext context) => const SelectDispositivoScreen(),
=======
>>>>>>> 762f46d6a76a325bb87e8044001012a9bf628564
  };
}
