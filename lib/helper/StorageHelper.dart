import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class StorageHelper {
  static Future<String> uploadPhoto(File image, String bucket) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference firebaseStorageRefrence = firebaseStorage.ref().child(bucket);
    TaskSnapshot taskSnapshot = await firebaseStorageRefrence.child('${DateTime.now().microsecondsSinceEpoch}.jpg').putFile(image);
    return await taskSnapshot.ref.getDownloadURL();
  }

  static Future<String> uploadByteDataPhoto(ByteData byteData, String bucket) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference firebaseStorageRefrence = firebaseStorage.ref().child(bucket);
    TaskSnapshot taskSnapshot = await firebaseStorageRefrence.child('${DateTime.now().microsecondsSinceEpoch}.jpg').putData(
          byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
        );
    return await taskSnapshot.ref.getDownloadURL();
  }
}
