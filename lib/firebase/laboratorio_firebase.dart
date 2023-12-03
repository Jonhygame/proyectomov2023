import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FavoritesFirebase {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CollectionReference? _favoritesColletion;

  FavoritesFirebase() {
    _favoritesColletion = _firebase.collection('favorites');
  }
  Future<void> insFavorites(Map<String, dynamic> map) async {
    return _favoritesColletion!.doc().set(map);
  }

  Future<void> updFavorite(Map<String, dynamic> map, String id) async {
    return _favoritesColletion!.doc(id).update(map);
  }

  Future<void> delFavorite(String id) async {
    return _favoritesColletion!.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllFavorites() {
    return _favoritesColletion!.snapshots();
  }
}
