import 'package:aractakip/services/authService.dart';
import 'package:aractakip/services/firebaseDB.dart';
import 'package:aractakip/services/firebaseStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class notificationsPage extends StatefulWidget {
  @override
  _notificationsPageState createState() => _notificationsPageState();
}

class _notificationsPageState extends State<notificationsPage> {

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: users
                    .doc(myAuth.authid())
                    .collection("notifications")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return new ListView(
                    children:
                    snapshot.data.docs.map((DocumentSnapshot document) {
                      return Container(
                        child: Column(
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                              future: users.doc(document.data()["id"]).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data =
                                  snapshot.data.data();
                                  return Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left:8.0),
                                                  child: CircleAvatar(
                                                    maxRadius: 30,
                                                    backgroundColor: Colors.white,
                                                    backgroundImage: data["profilepic"] != null
                                                        ? NetworkImage(data["profilepic"])
                                                        : AssetImage("assets/images/kurye.png"),
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(data["username"], style: TextStyle(fontSize: 22),),
                                                    Text(data["name"], style: TextStyle(fontSize: 14),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right:14.0),
                                              child: InkWell(
                                                child: Image.asset("assets/images/approve.png",width: 40,height: 40,),
                                                onTap: (){
                                                  Future.wait([
                                                    myDB.addRecFriendsList(document.data()["id"],data["username"]),
                                                    myDB.addMyFriendsList(document.data()["id"],data["username"]),
                                                    myDB.deletenotifications(document.id)
                                                  ]);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(thickness: 1, color: Colors.black.withOpacity(0.15),)
                                      ],
                                    ),
                                  );
                                }

                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
