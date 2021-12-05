import 'package:aractakip/services/authService.dart';
import 'package:aractakip/services/firebaseDB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class kuryeprofili extends StatefulWidget {
  final String id;
  kuryeprofili(this.id);
  @override
  _kuryeprofiliState createState() => _kuryeprofiliState();
}

class _kuryeprofiliState extends State<kuryeprofili> {
  AuthService auth = new AuthService();
  void friendsquest()async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.authid())
        .collection("friendslist")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc["id"] == widget.id){
          setState(() {
            useridquest = true;
          });
        }
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    friendsquest();
  }
  var useridquest = false;
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    if(widget.id == myAuth.authid()){
      useridquest = true;
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          Column(
            children: [
              useridquest != true ? IconButton(
                icon: Image.asset("assets/images/add.png"),
                iconSize: 40,
                onPressed: (){
                  myDB.sendaddfriends(widget.id);
                  AlertDialog alert = AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)
                    ),
                    backgroundColor: Colors.black,
                    title: Text("Kuryeye istek gönderildi"),
                    titleTextStyle: TextStyle(color: Colors.white,fontSize: 22),
                    actions: [
                      TextButton(child: Text("Çık",style: TextStyle(color: Colors.white,fontSize: 18),), onPressed: () {
                        Navigator.pop(context);
                      }),
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
              ) : IconButton(icon: Image.asset("assets/images/approve.png"),iconSize: 40, onPressed: (){},),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(widget.id).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 85,
                      backgroundImage: data["profilepic"] != null ?
                      NetworkImage(data["profilepic"]) :
                      AssetImage("assets/images/kurye.png"),
                    ),
                    SizedBox(height: 20,),
                    Text(data["username"],style: TextStyle(fontSize: 28,fontWeight:FontWeight.bold),),
                    Text(data["name"],style: TextStyle(fontSize: 24,fontWeight:FontWeight.w400),),
                    SizedBox(height: 2,),
                  ],
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
