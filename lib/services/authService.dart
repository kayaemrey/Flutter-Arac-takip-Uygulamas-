import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum userstatus {
  oturumacilmis,
  oturumacilmamis,
  oturumaciliyor,
}

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  userstatus _status = userstatus.oturumacilmamis;

  userstatus get status => _status;

  set status(userstatus value) {
    _status = value;
    notifyListeners();
  }

  AuthService() {
    _auth.authStateChanges().listen(lgstatus);
  }

  void lgstatus(User user) async {
    await FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        status = userstatus.oturumacilmamis;
      } else {
        status = userstatus.oturumacilmis;
      }
    });
  }

  void register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      status = userstatus.oturumacilmis;
    } on FirebaseAuthException catch (e) {
      status = userstatus.oturumacilmamis;
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      status = userstatus.oturumacilmamis;
    } catch (e) {
      print("$e");
    }
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

//AuthService
  String authid() {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid;
    return uid;
  }
}
