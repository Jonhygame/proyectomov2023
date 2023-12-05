import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectomov2023/screens/inicio_screen.dart';
import 'package:proyectomov2023/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          color: Colors.blueGrey.shade100,
          animationDuration: Duration(milliseconds: 600),
          backgroundColor: Colors.blueGrey,
          index: 1,
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
                //pantalla actual
                break;
              case 2:
                print('caso 2 ');
                Future.delayed(Duration(milliseconds: 600), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SettingsScreen(),
                      settings: RouteSettings(name: '/settings'),
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
      body: Center(
          child: Text(
        'Dashboard',
        style: GoogleFonts.lato(color: Colors.amber),
      )),
    );
  }
}
