import 'package:flutter/material.dart';

class SelectDispositivoScreen extends StatefulWidget {
  const SelectDispositivoScreen({super.key});

  @override
  State<SelectDispositivoScreen> createState() =>
      _SelectDispositivoScreenState();
}

class _SelectDispositivoScreenState extends State<SelectDispositivoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona el dispositivo'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contenedor transparente para ocupar espacio
            Container(height: 0),
            // Botón flotante 1
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addEquipo').then((value) {
                  setState(() {});
                });
              },
              child: Icon(Icons.computer),
            ),
            SizedBox(height: 16), // Espaciado entre los botones
            // Botón flotante 2
            FloatingActionButton(
              onPressed: () {
                // Acción del botón 2
              },
              child: Icon(Icons.camera),
            ),
          ],
        ),
      ),
    );
  }
}
