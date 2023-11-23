class FechaModel {
  int id;
  int dia;
  int mes;
  int ano;
  String hora;

  FechaModel(
      {required this.id,
      required this.dia,
      required this.mes,
      required this.ano,
      required this.hora});

  Map<String, dynamic> toMap() {
    return {
      'ID_Fecha': id,
      'Dia': dia,
      'Mes': mes,
      'Año': ano,
      'Hora': hora,
    };
  }

  static FechaModel fromMap(Map<String, dynamic> map) {
    return FechaModel(
      id: map['ID_Fecha'],
      dia: map['Dia'],
      mes: map['Mes'],
      ano: map['Ano'],
      hora: map['Hora'],
    );
  }
}
