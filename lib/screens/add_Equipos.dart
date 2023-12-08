import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyectomov2023/firebase/Equipos_firebase.dart';
import 'package:proyectomov2023/firebase/discos_firebase.dart';

class addEquipo extends StatefulWidget {
  addEquipo({super.key, this.id});
  String? id;
  @override
  _addEquipoState createState() => _addEquipoState();
}

class _addEquipoState extends State<addEquipo> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ramController = TextEditingController();
  final _fuenteController = TextEditingController();
  final _procesadorController = TextEditingController();
  final _comentarioController = TextEditingController();
  List<QueryDocumentSnapshot<Object?>> discos = [];
  Object? selectedidDisc;
  EquiposFirebase? _equiposFirebase;
  DiscosFirebase? _discosFirebase;

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _equiposFirebase = EquiposFirebase();
    _discosFirebase = DiscosFirebase();
  }

  void _guardarLaboratorio() {
    if (_formKey.currentState!.validate()) {
      String nombre = _nombreController.text;
      int ram = _ramController.text as int;

      // Guardar en la base de datos
      _equiposFirebase!
          .insEquipos({'Nombre': nombre, 'Ram': ram}).then((value) {
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

  bool estado = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Equipo de computo'),
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
              TextFormField(
                controller: _ramController,
                decoration: InputDecoration(
                  labelText: 'Ram',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa la ram';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fuenteController,
                decoration: InputDecoration(
                  labelText: 'Fuente de poder',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa una fuente';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _procesadorController,
                decoration: InputDecoration(
                  labelText: 'Procesador',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa un procesador';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text('Status'),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            estado = !estado;
                          });
                        },
                        child: SizedBox(
                          width: 60,
                          child: estado
                              ? Image.asset('assets/images/checked.png')
                              : Image.asset('assets/images/cross.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: _discosFirebase!.getAllDiscos(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    discos = snapshot.data!.docs;
                    return DropdownButtonFormField(
                      value: selectedidDisc,
                      items: discos.asMap().entries.map((disco) {
                        int index = disco.key;
                        return DropdownMenuItem(
                          value: index,
                          child: Text(disco.value.get('Marca') +
                              " " +
                              disco.value.get('Capacidad').toString() +
                              "GB " +
                              disco.value.get('Tipo')),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedidDisc = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Disco',
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              TextFormField(
                controller: _comentarioController,
                decoration: InputDecoration(
                  labelText: 'Comentarios??',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa algun comentario';
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
