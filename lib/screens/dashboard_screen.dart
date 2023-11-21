import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectomov2023/screens/login_screen.dart';

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
          animationDuration: Duration(milliseconds: 100),
          index: 1,
          onTap: (index) {
            switch (index) {
              case 0:
                print('caso 0 ');
                Future.delayed(Duration(milliseconds: 100), () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          LoginScreen(),
                      settings: RouteSettings(name: '/principal'),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                      transitionDuration: Duration(
                          milliseconds:
                              0), // Establecer la duración a 0 para desactivar la transición
                    ),
                  );
                });
                break;
              case 1:
                print('caso 1 ');
                //pantalla actual
                break;
              case 2:
                print('caso 2 ');
                Future.delayed(Duration(milliseconds: 100), () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DashboardScreen(),
                      settings: RouteSettings(name: '/lista'),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                      transitionDuration: Duration(
                          milliseconds:
                              0), // Establecer la duración a 0 para desactivar la transición
                    ),
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
        'asd',
        style: GoogleFonts.lato(color: Colors.amber),
      )),
    );
  }
}
