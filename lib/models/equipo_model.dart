class EquipoModel {
  int idEquipo;
  String nombre;
  String marca;
  int ram;
  String fuentePoder;
  String procesador;
  String estatus;
  int idDisco;
  int idComentario;
  int idSoftware;
  int idLaboratorio;

  EquipoModel({
    required this.idEquipo,
    required this.nombre,
    required this.marca,
    required this.ram,
    required this.fuentePoder,
    required this.procesador,
    required this.estatus,
    required this.idDisco,
    required this.idComentario,
    required this.idSoftware,
    required this.idLaboratorio,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Equipo': idEquipo,
      'Nombre': nombre,
      'Marca': marca,
      'RAM': ram,
      'Fuente_Poder': fuentePoder,
      'Procesador': procesador,
      'Estatus': estatus,
      'ID_Disco': idDisco,
      'ID_Comentario': idComentario,
      'ID_Software': idSoftware,
      'ID_Laboratorio': idLaboratorio,
    };
  }

  factory EquipoModel.fromMap(Map<String, dynamic> map) {
    return EquipoModel(
      idEquipo: map['ID_Equipo'],
      nombre: map['Nombre'],
      marca: map['Marca'],
      ram: map['RAM'],
      fuentePoder: map['Fuente_Poder'],
      procesador: map['Procesador'],
      estatus: map['Estatus'],
      idDisco: map['ID_Disco'],
      idComentario: map['ID_Comentario'],
      idSoftware: map['ID_Software'],
      idLaboratorio: map['ID_Laboratorio'],
    );
  }
}
