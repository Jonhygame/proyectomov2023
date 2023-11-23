import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/screens/dashboard_screen.dart';
import 'package:proyectomov2023/screens/inicio_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
      body: Center(
        child: Column(
          children: [
            const Text('Settings'),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: DayNightSwitcher(
                isDarkModeEnabled: GlobalValues.flagTheme.value,
                onStateChanged: (isDarkModeEnabled) {
                  GlobalValues.teme.setBool('teme', isDarkModeEnabled);
                  GlobalValues.flagTheme.value = isDarkModeEnabled;
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
