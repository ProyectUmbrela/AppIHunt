
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ihunt/vistas/inquilino/googleMaps.dart';
import 'package:ihunt/vistas/inquilino/misLugares.dart';
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
  String _idUsuario;
  String _nombre;


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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage  event) {
      setState(() {
        messageTitle = event.notification.title;
        //notificationAlert = "Application opened from Notification";
      });
    });
  }


  void setData() async{

    _currentUser = FirebaseAuth.instance.currentUser;

    var snapShoot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    setState(() {
      _nombre = snapShoot['nombre'];
      _idUsuario = snapShoot['usuario'];
    });
  }


  Future<void> saveTokenToDatabase(String token) async {

    // upsert, insert if not exists or add anew one if already exists
    var _current = await _currentUser.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_current)
        .set({
          'updatedOn': FieldValue.serverTimestamp(),
          'token': token},
          SetOptions(merge: true)
        );
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


  Widget projectWidget() {

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
                    child: Container(
                        child: AdWidget(
                          ad: AdmobHelper.getBannerAd()..load(),
                          key: UniqueKey(),),
                        height: AdmobHelper.getBannerAd().size.height.toDouble(),
                        width: AdmobHelper.getBannerAd().size.width.toDouble()
                    )
                )
            ),/*
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



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.airline_seat_individual_suite)),
                Tab(icon: Icon(Icons.search_sharp)),
                Tab(icon: Icon(Icons.notifications))
              ],
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Text("Salir"),
                  new IconButton(
                    icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white),
                    onPressed: _logout,
                  )
                ],
              )
            ],
            title: Text('Hola ${_nombre}'),
          ),
          body: TabBarView(
            physics: const  NeverScrollableScrollPhysics(),
            children: [
              projectWidget(),
              Lugares(),
              MyMaps(),
              NotificacionesInquilino()
            ],
          ),
        ),
      ),
    );
  }

}

