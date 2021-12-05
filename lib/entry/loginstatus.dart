import 'package:aractakip/entry/loginpage.dart';
import 'package:aractakip/screens/homepage.dart';
import 'package:aractakip/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class loginstatus extends StatefulWidget {
  @override
  _loginstatusState createState() => _loginstatusState();
}

class _loginstatusState extends State<loginstatus> {
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    switch (myAuth.status) {
      case userstatus.oturumaciliyor:
        return Scaffold(
          body: Center(
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      case userstatus.oturumacilmamis:
        return loginpage();
      case userstatus.oturumacilmis:
        return homepage();
    }
  }
}
