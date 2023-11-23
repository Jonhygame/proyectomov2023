class DiscoModel {
  int id;
  String marca;
  int capacidad;
  String tipo;

  DiscoModel(
      {required this.id,
      required this.marca,
      required this.capacidad,
      required this.tipo});

  factory DiscoModel.fromMap(Map<String, dynamic> map) {
    return DiscoModel(
      id: map['ID_Disco'],
      marca: map['Marca'],
      capacidad: map['Capacidad'],
      tipo: map['Tipo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID_Disco': id,
      'Marca': marca,
      'Capacidad': capacidad,
      'Tipo': tipo,
    };
  }
}
