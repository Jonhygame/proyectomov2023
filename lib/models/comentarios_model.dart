class ComentariosModel {
  int idComentario;
  String comentario;
  String responsable;
  int idFecha;

  ComentariosModel({
    required this.idComentario,
    required this.comentario,
    required this.responsable,
    required this.idFecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Comentario': idComentario,
      'Comentario': comentario,
      'Responsable': responsable,
      'ID_Fecha': idFecha,
    };
  }

  static ComentariosModel fromMap(Map<String, dynamic> map) {
    return ComentariosModel(
      idComentario: map['ID_Comentario'],
      comentario: map['Comentario'],
      responsable: map['Responsable'],
      idFecha: map['ID_Fecha'],
    );
  }
}
