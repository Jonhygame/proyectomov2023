import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyectomov2023/firebase/laboratorio_firebase.dart';

class DiscosFirebase {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CollectionReference? _discosColletion;

  DiscosFirebase() {
    _discosColletion = _firebase.collection('Discos');
  }
  Future<void> insDiscos(Map<String, dynamic> map) async {
    return _discosColletion!.doc().set(map);
  }

  Future<void> updDisco(Map<String, dynamic> map, String id) async {
    return _discosColletion!.doc(id).update(map);
  }

  Future<void> delDisco(String id) async {
    return _discosColletion!.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllDiscos() {
    return _discosColletion!.snapshots();
  }

  Future<QuerySnapshot<Object?>> getspecific(String id) async {
    //var data = _laboratoriosFirebase!.obtenerDatosDocumento(id);
    QuerySnapshot<Object?> data =
        await _discosColletion!.where('id', isEqualTo: id).get();
    return data;
  }

  Future<Map<String, dynamic>> obtenerDatosDocumento(String id) async {
    // Referencia al documento específico
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Discos').doc(id);
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
