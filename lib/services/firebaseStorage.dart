import 'package:aractakip/services/authService.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

AuthService auth = new AuthService();

class firebasestorage with ChangeNotifier {
  File _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    var image = (await ImagePicker.pickImage(source: ImageSource.gallery)) as XFile;
    _image = File(image.path);
    await firebase_storage.FirebaseStorage.instance
        .ref('profile/${auth.authid()}.png')
        .putFile(_image);
    debugPrint("add image");
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('profile/${auth.authid()}.png')
        .getDownloadURL();
    debugPrint(downloadURL);
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).set({"profilepic": downloadURL},SetOptions(merge: true)).then((value) => debugPrint("add users picture data"));
  }


}
