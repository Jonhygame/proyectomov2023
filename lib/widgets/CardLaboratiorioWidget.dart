import 'package:flutter/material.dart';

class CardLaboratorioWidget extends StatefulWidget {
  final int numeroComputadoras;
  const CardLaboratorioWidget({Key? key, required this.numeroComputadoras})
      : super(key: key);
  @override
  _CardLaboratorioWidgetState createState() => _CardLaboratorioWidgetState();
}

class _CardLaboratorioWidgetState extends State<CardLaboratorioWidget> {
  bool mostrarComputadoras = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Laboratorio'),
        //subtitle: Text('Número de computadoras: ${widget.numeroComputadoras}'),
        onTap: () {
          setState(() {
            mostrarComputadoras = !mostrarComputadoras;
          });
        },
        trailing: Icon(
            mostrarComputadoras ? Icons.arrow_drop_up : Icons.arrow_drop_down),
      ),
    );
  }
}
