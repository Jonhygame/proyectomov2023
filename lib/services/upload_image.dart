import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String?> uploadImage(File image) async {
  final String namefile = image.path.split("/").last;

  Reference ref = storage.ref().child("images").child(namefile);

  final UploadTask uploadTask = ref.putFile(image);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  final String url = await snapshot.ref.getDownloadURL();

  print('Este es el url: ' + url);

  return url; // Devuelve la URL después de cargar la imagen
}
