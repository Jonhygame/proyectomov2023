class ProyectorModel {
  int idProyector;
  String marca;
  String modelo;

  ProyectorModel(
      {required this.idProyector, required this.marca, required this.modelo});

  Map<String, dynamic> toMap() {
    return {
      'ID_Proyector': idProyector,
      'Marca': marca,
      'Modelo': modelo,
    };
  }

  static ProyectorModel fromMap(Map<String, dynamic> map) {
    return ProyectorModel(
      idProyector: map['ID_Proyector'],
      marca: map['Marca'],
      modelo: map['Modelo'],
    );
  }
}
