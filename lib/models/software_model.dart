class SoftwareModel {
  int idSoftware;
  String nombre;
  String clase;
  int idSO;

  SoftwareModel({
    required this.idSoftware,
    required this.nombre,
    required this.clase,
    required this.idSO,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Software': idSoftware,
      'Nombre': nombre,
      'Clase': clase,
      'ID_SO': idSO,
    };
  }

  static SoftwareModel fromMap(Map<String, dynamic> map) {
    return SoftwareModel(
      idSoftware: map['ID_Software'],
      nombre: map['Nombre'],
      clase: map['Clase'],
      idSO: map['ID_SO'],
    );
  }
}
