class LaboratorioModel {
  int idLaboratorio;
  String nombre;

  LaboratorioModel({required this.idLaboratorio, required this.nombre});

  Map<String, dynamic> toMap() {
    return {
      'ID_Laboratorio': idLaboratorio,
      'Nombre': nombre,
    };
  }

  factory LaboratorioModel.fromMap(Map<String, dynamic> map) {
    return LaboratorioModel(
      idLaboratorio: map['ID_Laboratorio'],
      nombre: map['Nombre'],
    );
  }
}
