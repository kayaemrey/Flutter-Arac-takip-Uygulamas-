import 'package:aractakip/screens/kuryeProfili.dart';
import 'package:aractakip/services/authService.dart';
import 'package:aractakip/services/firebaseDB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class kuryeEkle extends StatefulWidget {
  @override
  _kuryeEkleState createState() => _kuryeEkleState();
}

class _kuryeEkleState extends State<kuryeEkle> {
  TextEditingController txtsearch = TextEditingController();

  String name = "name";

  @override
  Widget build(BuildContext context) {
    final myDB = Provider.of<firebasedb>(context);
    final myAuth = Provider.of<AuthService>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
              controller: txtsearch,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: "Kullanıcı ara",
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: users.orderBy('username').startAt([name]).endAt([name + '\uf8ff']).limit(5).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return txtsearch.text.length == 0 ? Container() : ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        // decoration: BoxDecoration(
                        //     color: Colors.grey.shade200,
                        //     borderRadius: BorderRadius.circular(22)),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        CircleAvatar(
                                            backgroundColor: Colors.white,
                                            maxRadius: 35,
                                            backgroundImage: document.data()["profilepic"] != null
                                                ? NetworkImage(document.data()["profilepic"])
                                                : AssetImage("assets/images/kurye.png")),
                                        SizedBox(width: 10,),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              document.data()["username"],
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                                            Text(
                                              document.data()["name"],
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>kuryeprofili(document.id)));
                                },
                              ),
                              Divider(thickness: 1,color: Colors.black,),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
