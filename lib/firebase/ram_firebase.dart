import 'package:cloud_firestore/cloud_firestore.dart';

class RamFirebase {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CollectionReference? _ramColletion;

  RamFirebase() {
    _ramColletion = _firebase.collection('Ram');
  }
  Future<void> insRam(Map<String, dynamic> map) async {
    return _ramColletion!.doc().set(map);
  }

  Future<void> updRam(Map<String, dynamic> map, String id) async {
    return _ramColletion!.doc(id).update(map);
  }

  Future<void> delRam(String id) async {
    return _ramColletion!.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllRam() {
    return _ramColletion!.snapshots();
  }

  Future<QuerySnapshot<Object?>> getspecific(String id) async {
    //var data = _laboratoriosFirebase!.obtenerDatosDocumento(id);
    QuerySnapshot<Object?> data =
        await _ramColletion!.where('id', isEqualTo: id).get();
    return data;
  }

  Future<Map<String, dynamic>> obtenerDatosDocumento(String id) async {
    // Referencia al documento específico
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Ram').doc(id);
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
