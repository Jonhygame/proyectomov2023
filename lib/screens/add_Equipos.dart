import 'package:flutter/material.dart';
import 'package:proyectomov2023/database/database.dart';

class addEquipo extends StatefulWidget {
  @override
  _addEquipoState createState() => _addEquipoState();
}

class _addEquipoState extends State<addEquipo> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _guardarLaboratorio() {
    if (_formKey.currentState!.validate()) {
      String nombre = _nombreController.text;

      // Guardar en la base de datos
      Data().INSERT('Laboratorios', {'Nombre': nombre}).then((value) {
        var msj = (value > 0) ? 'La inserción fue exitosa' : 'Ocurrió un error';
        var snackbar = SnackBar(content: Text(msj));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pop(context);
      });
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laboratorio guardado')),
      );

      // Limpiar el formulario
      _nombreController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Laboratorio'),
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
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
