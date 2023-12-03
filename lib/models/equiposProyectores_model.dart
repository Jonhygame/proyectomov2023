import 'package:proyectomov2023/models/equipo_model.dart';
import 'package:proyectomov2023/models/proyector_model.dart';

class EquiposProyectoresModel {
  List<EquipoModel> equipos;
  List<ProyectorModel> proyectores;

  EquiposProyectoresModel({
    required this.equipos,
    required this.proyectores,
  });

  factory EquiposProyectoresModel.fromMap(Map<String, dynamic> map) {
    return EquiposProyectoresModel(
      equipos: List<EquipoModel>.from(
        map['equipos']?.map((x) => EquipoModel.fromMap(x)) ?? [],
      ),
      proyectores: List<ProyectorModel>.from(
        map['proyectores']?.map((x) => ProyectorModel.fromMap(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'equipos': equipos.map((x) => x.toMap()).toList(),
      'proyectores': proyectores.map((x) => x.toMap()).toList(),
    };
  }
}
