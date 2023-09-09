import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageProvider = Provider(
  (ref) => CommonFirebaseStorage(
    firebaseStorage: FirebaseStorage.instance,
  ),
);

class CommonFirebaseStorage {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorage({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
