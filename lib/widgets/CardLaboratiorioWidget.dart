import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/firebase/laboratorio_firebase.dart';
import 'package:proyectomov2023/screens/add_laboratorios.dart';
import 'package:proyectomov2023/screens/listarEquipos_screen.dart';

class CardLaboratorioWidget extends StatefulWidget {
  CardLaboratorioWidget(
      {super.key, required this.laboratorio, required this.index});
  QueryDocumentSnapshot? laboratorio;
  int index;

  @override
  State<CardLaboratorioWidget> createState() => _CardLaboratorioWidgetState();
}

class _CardLaboratorioWidgetState extends State<CardLaboratorioWidget> {
  LaboratoriosFirebase? _laboratoriosFirebase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _laboratoriosFirebase = LaboratoriosFirebase();
  }

  bool estado = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddLaboratorio(
                    id_lab: widget.laboratorio!.id,
                  ))),
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey.shade100,
        ),
        child: ListTile(
          title: Text(
            widget.index.toString() + " " + widget.laboratorio!.get('Nombre'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.laboratorio!.get('pc').toString(),
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
                          content: Text('¿Deseas borrar el Laboratorio?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  if (widget.laboratorio!.get('pc') != 0) {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Alerta'),
                                            content:
                                                Text('Computadoras Asignadas'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Entendido')),
                                            ],
                                          );
                                        });
                                  } else {
                                    _laboratoriosFirebase!
                                        .delLaboratorio(widget.laboratorio!.id);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Si',
                                    style: GlobalValues.flagTheme.value
                                        ? TextStyle(color: Colors.white)
                                        : TextStyle(color: Colors.black))),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('No',
                                    style: GlobalValues.flagTheme.value
                                        ? TextStyle(color: Colors.white)
                                        : TextStyle(color: Colors.black))),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListarEquipoScreen(
                                lab: widget.laboratorio!.id,
                                nom: widget.laboratorio!.get('Nombre'))));
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
