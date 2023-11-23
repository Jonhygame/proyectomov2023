class SistemaOperativoModel {
  int id;
  String nombre;
  String version;

  SistemaOperativoModel(
      {required this.id, required this.nombre, required this.version});

  Map<String, dynamic> toMap() {
    return {
      'ID_SO': id,
      'Nombre': nombre,
      'Versión': version,
    };
  }

  static SistemaOperativoModel fromMap(Map<String, dynamic> map) {
    return SistemaOperativoModel(
      id: map['ID_SO'],
      nombre: map['Nombre'],
      version: map['Versión'],
    );
  }
}
