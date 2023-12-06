import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/firebase/laboratorio_firebase.dart';
import 'package:proyectomov2023/screens/dashboard_screen.dart';
import 'package:proyectomov2023/screens/settings_screen.dart';
import 'package:proyectomov2023/widgets/CardLaboratiorioWidget.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  LaboratoriosFirebase? _laboratoriosFirebase;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _laboratoriosFirebase = LaboratoriosFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laboratorios',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/addLab',
                    (route) => true,
                  ).then((value) {
                    setState(() {
                      // Puedes realizar acciones después de que se complete la navegación
                    });
                  }),
              icon: const Icon(Icons.add)),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          color: Colors.blueGrey.shade100,
          animationDuration: Duration(milliseconds: 600),
          backgroundColor: Colors.blueGrey,
          index: 0,
          onTap: (index) {
            switch (index) {
              case 0:
                print('caso 0 ');
                //pantalla actual
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
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.flagPR4Task,
        builder: (context, value, _) {
          return StreamBuilder(
              stream: _laboratoriosFirebase!.getAllLaboratorios(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      //print(snapshot.data!.docs[index]);
                      //return Text('a');
                      return CardLaboratorioWidget(
                          laboratorio: snapshot.data!.docs[index],
                          index: index + 1);
                    },
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error!'),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              });
        },
      ),
    );
  }
}
