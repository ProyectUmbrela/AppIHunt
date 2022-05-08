import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ihunt/vistas/inquilino/googleMaps.dart';
import 'package:ihunt/vistas/inquilino/misLugares.dart';
import 'package:ihunt/vistas/inquilino/user_profile.dart';
import 'package:ihunt/vistas/inquilino/notificationesInquilino.dart';

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ihunt/vistas/inquilino/AdmobHelper.dart';

// AdMob
import 'package:google_mobile_ads/google_mobile_ads.dart';

class UserView extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserView> {
  User _currentUser;
  String _nombre;
  int _currentIndex = 0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String messageTitle = "Empty!";
  var tokenBy = '';

  @override
  void initState() {
    AdmobHelper.initialization();
    super.initState();
    setData();

    firebaseCloudMessaging_Listeners();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      setState(() {
        messageTitle = event.notification.title;
        //notificationAlert = "New Notification Alert";
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      setState(() {
        messageTitle = event.notification.title;
        //notificationAlert = "Application opened from Notification";
      });
    });
  }

  void setData() async {
    _currentUser = FirebaseAuth.instance.currentUser;

    var snapShoot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    //SharedPreferences localStorage = await SharedPreferences.getInstance();

    setState(() {
      _nombre = snapShoot['nombre'];
      //localStorage.setString('GlobalUserName', 'FREDY MARIN FLORES');
    });
  }

  Future<void> saveTokenToDatabase(String token) async {
    // upsert, insert if not exists or add anew one if already exists
    var _current = await _currentUser.uid;

    await FirebaseFirestore.instance.collection('users').doc(_current).set(
        {'updatedOn': FieldValue.serverTimestamp(), 'token': token},
        SetOptions(merge: true));
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) async {
      await saveTokenToDatabase(token);
      tokenBy = token;
      _firebaseMessaging.onTokenRefresh.listen(saveTokenToDatabase);
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget widgetHome() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(0.5),
        padding: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0, 1],
                colors: [Colors.blue[100], Colors.blue[200]],
                tileMode: TileMode.repeated),
            borderRadius: BorderRadius.circular(10.0)),
        alignment: FractionalOffset.center,
        child: Column(
          children: <Widget>[
            Align(
                alignment: FractionalOffset.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  //child: projectWidgetAd(),
                  child: Container(
                        child: AdWidget(
                          ad: AdmobHelper.getBannerAd()..load(),
                          key: UniqueKey(),),
                        height: AdmobHelper.getBannerAd().size.height.toDouble(),
                        width: AdmobHelper.getBannerAd().size.width.toDouble()
                    )
                )),
            /*
             Container(
               child: Icon(Icons.person ,
                 color: Colors.white,
                 size: 50.0,
               ),
            ),
            getRow(id_usuario, 15.0, 0.6), ##################################### icono de usuario y notificaciones
            Text(
              messageTitle,
              style: Theme.of(context).textTheme.headline4,
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _getView(int index) {
    switch (index) {
      case 0:
        return widgetHome(); //first page
      case 1:
        return Lugares(); // second page
      case 2:
        return MyMaps(); // third page
      case 3:
        return NotificacionesInquilino(); // fourth page
    }

    return Center(child: Text("No disponible"),);
  }

  Widget menuOptions(){
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '$_nombre',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Cuenta',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Notificaciones',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text(
              'Ayuda',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Update the state of the app.

            },
          ),
          ListTile(
            title: Text(
              'Salir',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );

  }

  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child:_getView(_currentIndex)),
      appBar: AppBar(
          title: Center(
              child: Text(
                'RentI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              )
          )
      ),
      endDrawer: menuOptions(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.primary,
        selectedItemColor: Colors.white,
        onTap: (value) {
          // Si el index es distinto a la vista actual
          if(_currentIndex != value){
            setState(() => _currentIndex = value);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airline_seat_individual_suite),
            label: 'Hbitaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Lugares',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Invitaciones',
          ),
        ],
      ),
    );
  }
}

