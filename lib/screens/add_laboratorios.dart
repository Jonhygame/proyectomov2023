import 'package:flutter/material.dart';
import 'package:proyectomov2023/database/database.dart';
import 'package:proyectomov2023/firebase/laboratorio_firebase.dart';

class AddLaboratorio extends StatefulWidget {
  AddLaboratorio({super.key, this.id_lab});
  String? id_lab;
  @override
  _AddLaboratorioState createState() => _AddLaboratorioState();
}

class _AddLaboratorioState extends State<AddLaboratorio> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  LaboratoriosFirebase? _laboratoriosFirebase;
  late int pc = 0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _laboratoriosFirebase = LaboratoriosFirebase();
    if (widget.id_lab != null) {
      var data = _laboratoriosFirebase!
          .obtenerDatosDocumento(widget.id_lab.toString());
      data.then((value) {
        _nombreController.text = value.entries.first.value;
        pc = value.entries.last.value;
      }); //importante
    }
  }

  void _guardarLaboratorio() {
    if (_formKey.currentState!.validate()) {
      String nombre = _nombreController.text;

      // Guardar en la base de datos
      if (widget.id_lab == null) {
        _laboratoriosFirebase!
            .insLaboratorios({"Nombre": nombre, "pc": 0}).then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Laboratorio guardado')),
                    ));
      } else {
        _laboratoriosFirebase!
            .updLaboratorio({"Nombre": nombre, "pc": pc}, widget.id_lab);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.id_lab == null
            ? Text('Agregar Laboratorio')
            : Text('Editar Laboratorio'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _guardarLaboratorio,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
