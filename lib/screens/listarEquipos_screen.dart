import 'package:flutter/material.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/database/database.dart';
import 'package:proyectomov2023/models/equipo_model.dart';

class ListarEquipoScreen extends StatefulWidget {
  const ListarEquipoScreen({super.key});

  @override
  State<ListarEquipoScreen> createState() => _ListarEquipoScreenState();
}

class _ListarEquipoScreenState extends State<ListarEquipoScreen> {
  Data? data;
  String searchTerm = '';
  int? selectedTaskStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = Data();
  }

  @override
  Widget build(BuildContext context) {
    final datos =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laboratorio ' + datos['id'].toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/addEquipo').then((value) {
                    setState(() {});
                  }),
              icon: const Icon(Icons.task)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      value = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar Laboratorio...',
                  ),
                ),
                SizedBox(height: 5.0),
              ],
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.flagPR4Task,
        builder: (context, value, _) {
          return FutureBuilder(
              future: data!.searchEquipo(datos['id'], searchTerm),
              builder: (BuildContext context,
                  AsyncSnapshot<List<EquipoModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      //return CardLaboratorioWidget(laboratorioModel: snapshot.data![index], data: data);
                      return Text('a');
                    },
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error!'),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              });
        },
      ),
    );
  }
}
