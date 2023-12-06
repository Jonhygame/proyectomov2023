import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/firebase/Equipos_firebase.dart';
import 'package:proyectomov2023/firebase/laboratorio_firebase.dart';
import 'package:proyectomov2023/screens/add_laboratorios.dart';

class CardEquipoWidget extends StatefulWidget {
  CardEquipoWidget({super.key, required this.equipo, required this.index});
  QueryDocumentSnapshot equipo;
  int index;

  @override
  State<CardEquipoWidget> createState() => _CardEquipoWidgetState();
}

class _CardEquipoWidgetState extends State<CardEquipoWidget> {
  LaboratoriosFirebase? _laboratoriosFirebase;
  EquiposFirebase? _equiposFirebase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _laboratoriosFirebase = LaboratoriosFirebase();
    _equiposFirebase = EquiposFirebase();
  }

  bool estado = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddLaboratorio(
                    id_lab: widget.equipo.id,
                  ))),
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey.shade100,
        ),
        child: ListTile(
          title: Text(
            widget.index.toString() + " " + widget.equipo.get('Nombre'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "2",
            //widget.equipo.get('pc').toString(),
            //_equiposFirebase!.getEquipo(widget.laboratorio.id),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: SizedBox(
            width: 126,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      estado = !estado;
                    });
                  },
                  child: SizedBox(
                    width: 30,
                    child: estado
                        ? Image.asset('assets/images/cross.png')
                        : Image.asset('assets/images/checked.png'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Mensaje del sistema'),
                          content: Text('¿Deseas borrar el Equipo?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _equiposFirebase!.delEquipo(widget.equipo.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Si')),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('No')),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listarEquipos',
                        arguments: {'id': widget.equipo.id});
                  },
                  icon: Icon(
                    Icons.arrow_right_sharp,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
