import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/database/database.dart';
import 'package:proyectomov2023/firebase/Equipos_firebase.dart';
import 'package:proyectomov2023/firebase/laboratorio_firebase.dart';
import 'package:proyectomov2023/screens/add_Equipos.dart';
import 'package:proyectomov2023/widgets/CardEquiposWidget.dart';

class ListarEquipoScreen extends StatefulWidget {
  ListarEquipoScreen({super.key, required this.lab, required this.nom});
  String lab;
  String nom;
  @override
  State<ListarEquipoScreen> createState() => _ListarEquipoScreenState();
}

class _ListarEquipoScreenState extends State<ListarEquipoScreen> {
  Data? data;
  String searchTerm = '';
  int? selectedTaskStatus;
  EquiposFirebase? _equiposFirebase;
  LaboratoriosFirebase? _laboratoriosFirebase;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _equiposFirebase = EquiposFirebase();
    _laboratoriosFirebase = LaboratoriosFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laboratorio ' + widget.nom,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => addEquipo(
                            id: widget.lab,
                          ))),
              icon: const Icon(Icons.computer)),
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/selectAddSpec').then((value) {
                    setState(() {});
                  }),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.flagPR4Task,
        builder: (context, value, _) {
          return FutureBuilder(
              future: _equiposFirebase!.getspecific(widget.lab),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      //print(snapshot.data!.docs[index].data());
                      //return Text('a');
                      return CardEquipoWidget(
                          equipo: snapshot.data!.docs[index], index: index + 1);
                    },
                  );
                } else {
                  if (snapshot.hasError) {
                    //print(snapshot);
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
