import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/database/database.dart';
import 'package:proyectomov2023/models/laboratorios_model.dart';
import 'package:proyectomov2023/screens/dashboard_screen.dart';
import 'package:proyectomov2023/screens/settings_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  Data? data;
  String searchTerm = '';
  int? selectedTaskStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = Data();
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
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/addLab').then((value) {
                    setState(() {});
                  }),
              icon: const Icon(Icons.task)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      value = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar Laboratorio...',
                  ),
                ),
                SizedBox(height: 5.0),
              ],
            ),
          ),
        ),
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
                      transitionDuration: Duration(milliseconds: 0),
                    ),
                  );
                });
                break;
              case 2:
                print('caso 2 ');
                Future.delayed(Duration(milliseconds: 600), () {
                  Navigator.push(
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
          return FutureBuilder(
              future: data!.searchLab(searchTerm, selectedTaskStatus),
              builder: (BuildContext context,
                  AsyncSnapshot<List<LaboratorioModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardLaboratorioWidget()
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
