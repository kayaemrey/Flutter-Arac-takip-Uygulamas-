import 'package:aractakip/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

AuthService auth = new AuthService();

class firebasedb with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> adduser(String email, String password, String name,
      String username, String kimlik) async {
    Map<String, dynamic> users = Map();
    users["email"] = email;
    users["password"] = password;
    users["name"] = name;
    users["username"] = username;
    users["kimlik"] = kimlik;
    users["registertime"] = DateTime.now();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.authid())
        .set(users, SetOptions(merge: true))
        .then((value) => debugPrint("add user data"));
  }

  void addData(var data, var eklenecek) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.authid())
        .set({eklenecek: data}, SetOptions(merge: true));
  }

  void creatMygroups(String id, String game) async {
    Map<String, dynamic> groups = Map();
    groups["id"] = id;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.authid())
        .collection(game)
        .doc()
        .set(groups, SetOptions(merge: true))
        .then((value) => debugPrint("add user data"));
  }

  void creatTogroups(String id, String yazilacakid, String game) async {
    Map<String, dynamic> groups = Map();
    groups["id"] = id;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(yazilacakid)
        .collection(game)
        .doc()
        .set(groups, SetOptions(merge: true))
        .then((value) => debugPrint("add user data"));
  }

  Future<void> addMyFriendsList(String id, String username) async {
    Map<String, dynamic> addfriends = Map();
    addfriends["id"] = id;
    addfriends["username"] = username;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.authid())
        .collection("friendslist")
        .doc(id)
        .set(addfriends, SetOptions(merge: true))
        .then((value) => debugPrint("add $id user data"));
  }

  Future<void> addRecFriendsList(String id, String username) async {
    Map<String, dynamic> addfriends = Map();
    addfriends["id"] = auth.authid();
    addfriends["username"] = username;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("friendslist")
        .doc(auth.authid())
        .set(addfriends, SetOptions(merge: true))
        .then((value) => debugPrint("add $id user data"));
  }

  Future<void> sendaddfriends(String id) async {
    Map<String, dynamic> addfriends = Map();
    addfriends["id"] = auth.authid();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("notifications")
        .doc()
        .set(addfriends, SetOptions(merge: true))
        .then((value) => debugPrint("add user data"));
  }

  Future<void> deletenotifications(String id) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(auth.authid())
        .collection("notifications")
        .doc(id)
        .delete()
        .then((value) => print("notifications Deleted"))
        .catchError((error) => print("Failed to delete notifications: $error"));
  }

  Future<void> addreport(String subject, String explanation, String id) async {
    Map<String, dynamic> addfriends = Map();
    addfriends["subject"] = subject;
    addfriends["explanation"] = explanation;
    addfriends["problem id"] = id;
    await FirebaseFirestore.instance
        .collection("report")
        .doc()
        .set(addfriends, SetOptions(merge: true))
        .then((value) => debugPrint("add report data"));
  }

  void createMessage(
      var myregister, var userregister, var message, var sendid) async {
    Map<String, dynamic> message = Map();
    message["message"] = message;
    message["sendid"] = sendid;
    message["date"] = DateTime.now();
    message["datehour"] = DateTime.parse("hh:mm");
    if (myregister > userregister) {
      await FirebaseFirestore.instance
          .collection("message")
          .doc(myregister + userregister)
          .set(message, SetOptions(merge: true))
          .then((value) => debugPrint("add message"));
    } else {
      await FirebaseFirestore.instance
          .collection("message")
          .doc(userregister + myregister)
          .set(message, SetOptions(merge: true))
          .then((value) => debugPrint("add message"));
    }
  }

  void sendmessage(
      String id, String sendmessage, DateTime time, String username) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('hh-mm');
    final String formatted = formatter.format(now);
    Map<String, dynamic> message = Map();
    message["message"] = sendmessage;
    message["sendid"] = auth.authid();
    message["time"] = time;
    message["timehm"] = formatted;
    message["username"] = username;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.authid())
        .collection("creatmessage")
        .doc(id)
        .collection("data")
        .doc()
        .set(message, SetOptions(merge: true));
  }

  void recevmessage(
      String id, String sendmessage, DateTime time, String username) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('hh-mm');
    final String formatted = formatter.format(now);
    Map<String, dynamic> message = Map();
    message["message"] = sendmessage;
    message["sendid"] = auth.authid();
    message["time"] = time;
    message["timehm"] = formatted;
    message["username"] = username;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("creatmessage")
        .doc(auth.authid())
        .collection("data")
        .doc()
        .set(message, SetOptions(merge: true));
  }

  void docidwrite(String id) async {
    Map<String, dynamic> groups = Map();
    groups["id"] = id;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.authid())
        .collection("creatmessage")
        .doc(id)
        .set(groups, SetOptions(merge: true))
        .then((value) => debugPrint("add docidwrite $id"));
  }

  void docrecidwrite(String id) async {
    Map<String, dynamic> groups = Map();
    groups["id"] = auth.authid();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("creatmessage")
        .doc(auth.authid())
        .set(groups, SetOptions(merge: true))
        .then((value) => debugPrint("add docrecidwrite data $id"));
  }
  //add prop id to delete messages
  // Future<void> deleteMyMessage(String userid,String silinecekid) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   return users
  //       .doc(auth.authid())
  //       .collection("creatmessage")
  //       .doc(userid)
  //       .collection("data")
  //       .doc(silinecekid)
  //       .delete()
  //       .then((value) => print("message Deleted"))
  //       .catchError((error) => print("Failed to delete message: $error"));
  // }
  // Future<void> deleteUserMessage(String userid,String silinecekid) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   return users
  //       .doc(userid)
  //       .collection("creatmessage")
  //       .doc(auth.authid())
  //       .collection("data")
  //       .doc(silinecekid)
  //       .delete()
  //       .then((value) => print("message Deleted ${auth.authid()} $userid"))
  //       .catchError((error) => print("Failed to delete message: $error"));
  // }

}
