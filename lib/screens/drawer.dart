import 'package:aractakip/maps/locationMaps.dart';
import 'package:aractakip/screens/bildirimler.dart';
import 'package:aractakip/screens/kuryeEkle.dart';
import 'package:aractakip/services/authService.dart';
import 'package:aractakip/services/firebaseDB.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class drawerpage extends StatefulWidget {
  @override
  _drawerpageState createState() => _drawerpageState();
}

class _drawerpageState extends State<drawerpage> {
  int number = 0;

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange.shade500,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/kurye.png",width: 80,),
                  Text("AracTakip",style: TextStyle(fontSize: 30),),
                ],
              )),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Kurye Ekle'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => kuryeEkle()));
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Location Maps'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LocationMap()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notification_important),
            title: Text('Bildirimler'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => notificationsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Hakkımzda'),
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => aboutpage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Çıkış yap'),
            onTap: () {
              myAuth.signout();
            },
          ),
        ],
      ),
    );
  }
}