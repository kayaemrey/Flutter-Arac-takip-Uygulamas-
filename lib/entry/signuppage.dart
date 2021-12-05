import 'package:aractakip/services/authService.dart';
import 'package:aractakip/services/firebaseDB.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class signuppage extends StatefulWidget {
  @override
  _signuppageState createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  TextEditingController txtmail = TextEditingController();
  TextEditingController txtpas = TextEditingController();
  TextEditingController txtname = TextEditingController();
  TextEditingController txtusername = TextEditingController();
  TextEditingController txtabout = TextEditingController();
  String dropdownValue = 'satıcı';
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Image.asset(
                        "assets/images/back.png",
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ),
              Image.asset(
                "assets/images/kurye.png",
                width: 144,
                height: 144,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "AracTakipApp",
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 8, top: 8),
                child: TextField(
                  controller: txtmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "E-mail giriniz",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 8, top: 8),
                child: TextField(
                  controller: txtpas,
                  maxLength: 14,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Şifre giriniz",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 5, bottom: 8, top: 8),
                      child: TextField(
                        controller: txtname,
                        maxLength: 22,
                        decoration: InputDecoration(
                          hintText: "İsim - soyisim",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 20, bottom: 8, top: 8),
                      child: TextField(
                        controller: txtusername,
                        maxLength: 17,
                        decoration: InputDecoration(
                          hintText: "Kullanıcı adı",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Kimliğinizi Seçin : ",style: TextStyle(color: Colors.black, fontSize: 18),),
                  SizedBox(width: 10,),
                  DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>["satıcı", "kurye"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 70),
                  child: Text(
                    "KAYIT OL",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  if (txtmail.text.isEmpty &&
                      txtpas.text.isEmpty &&
                      txtname.text.isEmpty &&
                      txtusername.text.isEmpty
                      ) {
                    AlertDialog alert = AlertDialog(
                      title: Text("empty box"),
                      content: Text(
                          "Please do not leave blank the fields you need to enter."),
                      actions: [
                        TextButton(
                            child: Text("okey"),
                            onPressed: () {
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
                  } else {
                    await myAuth.register(txtmail.text, txtpas.text);
                    await myDB.adduser(txtmail.text, txtpas.text, txtname.text, txtusername.text, dropdownValue);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
