import 'package:flutter/material.dart';
import 'package:proyectomov2023/database/database.dart';
import 'package:proyectomov2023/models/laboratorios_model.dart';

class CardLaboratorioWidget extends StatefulWidget {
  CardLaboratorioWidget({super.key, required this.laboratorioModel, this.data});
  LaboratorioModel laboratorioModel;
  Data? data;

  @override
  State<CardLaboratorioWidget> createState() => _CardLaboratorioWidgetState();
}

class _CardLaboratorioWidgetState extends State<CardLaboratorioWidget> {
  int contar(int id) {
    int contador = 0;
    widget.data!.SELECTEQUIPOS(id).then((value) {
      contador = value.length;
    });
    return contador;
  }

  bool estado = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey.shade100,
      ),
      child: ListTile(
        title: Text(
          widget.laboratorioModel.nombre,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          contar(widget.laboratorioModel.idLaboratorio).toString(),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: SizedBox(
          width: 126,
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: estado
                    ? Image.asset('assets/images/cross.png')
                    : Image.asset('assets/images/checked.png'),
              ),
              IconButton(
                onPressed: () {
                  widget.data!
                      .DELETE(
                          'Laboratorios', widget.laboratorioModel.idLaboratorio)
                      .then((value) {
                    var msj = (value > 0)
                        ? 'La eliminación fue exitosa'
                        : 'Ocurrió un error';
                    var snackbar = SnackBar(content: Text(msj));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.pop(context);
                  });
                },
                icon: Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/listarEquipos',
                      arguments: {'id': widget.laboratorioModel.nombre});
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
    );
  }
}
