import 'package:cloud_firestore/cloud_firestore.dart';

class EquiposFirebase {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CollectionReference? _equiposColletion;

  EquiposFirebase() {
    _equiposColletion = _firebase.collection('Equipos');
  }
  Future<void> insEquipos(Map<String, dynamic> map) async {
    return _equiposColletion!.doc().set(map);
  }

  Future<void> updEquipo(Map<String, dynamic> map, String id) async {
    return _equiposColletion!.doc(id).update(map);
  }

  Future<void> delEquipo(String id) async {
    return _equiposColletion!.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllEquipos() {
    return _equiposColletion!.snapshots();
  }

  Future<QuerySnapshot<Object?>> getspecific(String id) async {
    //var data = _laboratoriosFirebase!.obtenerDatosDocumento(id);
    QuerySnapshot<Object?> data =
        await _equiposColletion!.where('id', isEqualTo: id).get();
    return data;
  }

  Future<Map<String, dynamic>> obtenerDatosDocumento(String id) async {
    // Referencia al documento específico
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Equipos').doc(id);
    // Obtener el snapshot del documento
    DocumentSnapshot<Object?> snapshot = await documentReference.get();
    // Verificar si el documento existe
    if (snapshot.exists) {
      // Acceder a los datos del documento
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // Hacer algo con los datos
      //print(data);
      return data;
    } else {
      //print('El documento no existe.');
      return {"error": "error"};
    }
  }
}
