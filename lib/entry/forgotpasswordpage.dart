import 'package:aractakip/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class forgotpasswordpage extends StatefulWidget {
  @override
  _forgotpasswordpageState createState() => _forgotpasswordpageState();
}

class _forgotpasswordpageState extends State<forgotpasswordpage> {
  TextEditingController txtmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    return Scaffold(
      body: SingleChildScrollView(
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
            SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/images/kurye.png",
              width: 168,
              height: 168,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "AracTakipApp",
              style: TextStyle(fontSize: 34),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: txtmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your E-mail",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                child: Text(
                  "Reset password",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              onPressed: () {
                if (txtmail.text.isNotEmpty) {
                  myAuth.resetPassword(txtmail.text);
                  txtmail.clear();
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
