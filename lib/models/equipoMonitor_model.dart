class EquipoMonitorModel {
  int idMonitor;
  int idEquipo;
  int idProyector;
  String nombre;

  EquipoMonitorModel({
    required this.idMonitor,
    required this.idEquipo,
    required this.idProyector,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Monitor': idMonitor,
      'ID_Equipo': idEquipo,
      'ID_Proyector': idProyector,
      'Nombre': nombre,
    };
  }

  factory EquipoMonitorModel.fromMap(Map<String, dynamic> map) {
    return EquipoMonitorModel(
      idMonitor: map['ID_Monitor'],
      idEquipo: map['ID_Equipo'],
      idProyector: map['ID_Proyector'],
      nombre: map['Nombre'],
    );
  }
}
