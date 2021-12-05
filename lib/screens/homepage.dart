import 'package:aractakip/maps/locationMaps.dart';
import 'package:aractakip/screens/drawer.dart';
import 'package:aractakip/screens/googleMaps.dart';
import 'package:aractakip/services/authService.dart';
import 'package:aractakip/services/firebaseDB.dart';
import 'package:aractakip/services/firebaseStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  firebasedb db = new firebasedb();
  AuthService auth = new AuthService();

  var locationMessage = '';
  var latitude;
  var longitude;

  int kayitlisayac = 0;
  int aktifsayac = 0;
  void kayitlikuryesayisi(){
    FirebaseFirestore.instance
        .collection('users').doc(auth.authid()).collection("friendslist")
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              kayitlisayac += 1;
            });
          });
        });
  }
  void aktifkuryesayisi(){
    FirebaseFirestore.instance
        .collection('users').doc(auth.authid()).collection("friendslist")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc.data()["aktif"] == true){}
        setState(() {
          aktifsayac += 1;
        });
      });
    });
  }


  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings


    setState(() {
      latitude = lat;
      longitude = long;
    });
  }
  void lokasyonyazdir(){
    var num = 0;
    while(num <= 480){
      db.addData(latitude, "lat");
      db.addData(longitude, "long");
      sleep(Duration(seconds:5));
      num++;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    kayitlikuryesayisi();
    aktifkuryesayisi();
  }
  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').doc(auth.authid()).collection("friendslist").snapshots();
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    final myStorage = Provider.of<firebasestorage>(context);

    return Scaffold(
      drawer: drawerpage(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(myAuth.authid()).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data.data();
                return data["kimlik"] == "satıcı" ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      InkWell(
                        child: CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          maxRadius: 70,
                          backgroundImage: data["profilepic"] != null ?
                          NetworkImage(data["profilepic"]) :
                          AssetImage("assets/images/kurye.png"),
                        ),
                        onTap: (){
                          myStorage.getImage();
                        },
                      ),
                      SizedBox(height: 20,),
                      Text(data["name"],style: TextStyle(fontSize: 22),),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade300
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Text("Kayıtlı kurye : "),
                                  Text(kayitlisayac.toString()),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade300
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Text("Aktif kurye : "),
                                  Text("0"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _usersStream,
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return new ListView(
                              children: snapshot.data.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                print(kayitlisayac);
                                return Container(
                                  child: FutureBuilder<DocumentSnapshot>(
                                    future: users.doc(document.id).get(),
                                    builder:
                                        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                      if (snapshot.hasError) {
                                        return Text("Something went wrong");
                                      }

                                      if (snapshot.hasData && !snapshot.data.exists) {
                                        return Text("Document does not exist");
                                      }

                                      if (snapshot.connectionState == ConnectionState.done) {
                                        Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                                        return Container(
                                          child: Column(
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
                                                            Text(data["username"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                                                            Text(data["name"], style: TextStyle(fontSize: 14),),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MapSample(data["lat"],data["long"],document.id)));
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return Center(child: CircularProgressIndicator());
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ) : Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      InkWell(
                        child: CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          maxRadius: 70,
                          backgroundImage: data["profilepic"] != null ?
                          NetworkImage(data["profilepic"]) :
                          AssetImage("assets/images/kurye.png"),
                        ),
                        onTap: (){
                          myStorage.getImage();
                        },
                      ),
                      SizedBox(height: 20,),
                      Text(data["name"],style: TextStyle(fontSize: 22),),
                      SizedBox(height: 40,),
                      OutlinedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationMap()));
                      }, child: Text("Haritayı aç")
                      ),

                    ],
                  ),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
