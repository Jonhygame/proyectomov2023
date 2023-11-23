class MonitorModel {
  int id;
  String modelo;
  String marca;

  MonitorModel({required this.id, required this.modelo, required this.marca});

  factory MonitorModel.fromMap(Map<String, dynamic> map) {
    return MonitorModel(
      id: map['ID_Monitor'],
      modelo: map['Modelo'],
      marca: map['Marca'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID_Monitor': id,
      'Modelo': modelo,
      'Marca': marca,
    };
  }
}
