import 'package:cloud_firestore/cloud_firestore.dart';

class LaboratoriosFirebase {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CollectionReference? _laboratoriosColletion;

  LaboratoriosFirebase() {
    _laboratoriosColletion = _firebase.collection('Laboratorios');
  }
  Future<void> insLaboratorios(Map<String, dynamic> map) async {
    return _laboratoriosColletion!.doc().set(map);
  }

  Future<void> updLaboratorio(Map<String, dynamic> map, String? id) async {
    return _laboratoriosColletion!.doc(id).update(map);
  }

  Future<void> delLaboratorio(String id) async {
    return _laboratoriosColletion!.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllLaboratorios() {
    return _laboratoriosColletion!.snapshots();
  }

  Future<Map<String, dynamic>> obtenerDatosDocumento(String id) async {
    // Referencia al documento específico
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Laboratorios').doc(id);
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
