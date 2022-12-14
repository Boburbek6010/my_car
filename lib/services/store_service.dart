import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StoreService{
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = "car_folder";

  static Future<String>uploadImage(File image)async{
    String imageName = "image_${DateTime.now()}";
    Reference reference = _storage.child(folder).child(imageName);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}