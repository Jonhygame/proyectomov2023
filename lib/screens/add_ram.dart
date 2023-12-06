import 'package:flutter/material.dart';

class AddRamScreen extends StatefulWidget {
  @override
  _AddRamScreenState createState() => _AddRamScreenState();
}

class _AddRamScreenState extends State<AddRamScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _capacidad;
  late String _marca;
  late String _tipo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add RAM'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Capacidad',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
                onSaved: (value) {
                  _capacidad = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Marca',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the brand';
                  }
                  return null;
                },
                onSaved: (value) {
                  _marca = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tipo',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tipo = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
