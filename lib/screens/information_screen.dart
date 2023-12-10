import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InformationScreen(),
    );
  }
}

class InformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPage(
        data: [
          TarjetaData(
            title: "Bienvenido",
            subtitle:
                "Presiona el botón para iniciar sesión. En esta aplicación buscamos llevar a cabo un control de inventario",
            image: AssetImage('assets/images/celaya.jpg'),
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            titleColor: Color.fromARGB(255, 255, 255, 255),
            subtitleColor: Color.fromARGB(255, 255, 255, 255),
            background: LottieBuilder.asset("assets/animations/AP1.json"),
          ),
          TarjetaData(
            title: "¿Qué tipo de inventario?",
            subtitle:
                "Bueno, pues inicialmente todo el control de los equipos de computo de Campus II.",
            image: AssetImage('assets/images/lab1.jpg'),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            titleColor: Color.fromARGB(255, 0, 0, 0),
            subtitleColor: Color.fromARGB(255, 0, 0, 0),
            background: LottieBuilder.asset("assets/animations/AP2.json"),
          ),
          TarjetaData(
            title: "¿Dónde están esos equipos?",
            subtitle:
                "La mayoria están en el edificio de UTICS y es ahí donde vamos a comenzar.",
            image: AssetImage('assets/images/campus.jpg'),
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            titleColor: Color.fromARGB(255, 255, 255, 255),
            subtitleColor: Color.fromARGB(255, 255, 255, 255),
            background: LottieBuilder.asset("assets/animations/AP3.json"),
          ),
          TarjetaData(
            title: "¿Cómo lo harán?",
            subtitle: "Bueno, inicia sesión y lo averiguarás.",
            image: AssetImage('assets/images/utic.JPG'),
            backgroundColor: Color.fromARGB(255, 97, 252, 92),
            titleColor: Color.fromARGB(255, 0, 0, 0),
            subtitleColor: Color.fromARGB(255, 0, 0, 0),
            background: LottieBuilder.asset("assets/animations/AP1.json"),
          ),
        ],
      ),
    );
  }
}

class ConcentricPage extends StatelessWidget {
  final List<TarjetaData> data;

  ConcentricPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        itemBuilder: (int index) {
          return Tarjeta(data: data[index]);
        },
      ),
    );
  }
}

class Tarjeta extends StatelessWidget {
  final TarjetaData data;

  Tarjeta({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: data.backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: data.image,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            data.title,
            style: TextStyle(
              color: data.titleColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.subtitle,
            style: TextStyle(
              color: data.subtitleColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text("Iniciar Sesión"),
          ),
        ],
      ),
    );
  }
}

class TarjetaData {
  final String title;
  final String subtitle;
  final AssetImage image;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Widget background;

  TarjetaData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.background,
  });
}
