
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ihunt/vistas/inquilino/google_maps.dart';
import 'package:ihunt/vistas/inquilino/mis_lugares.dart';
import 'package:shared_preferences/shared_preferences.dart';
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


  String id_usuario;
  String nombre;
  String tipo_usuario;


  //############################################################################
  //###########################################################################1


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String messageTitle = "Empty!";
  //String notificationAlert = "Alert";
  var tokenBy = '';

  //###########################################################################1
  //############################################################################


  @override
  void initState() {
    setData();
    AdmobHelper.initialization();
    //##########################################################################
    //#########################################################################1

    super.initState();
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

    //#########################################################################1
    //##########################################################################

  }




  //############################################################################
  //###########################################################################1

  Future<void> saveTokenToDatabase(String token) async {

    // upsert, insert if not exists or add anew one if already exists
    await FirebaseFirestore.instance
        .collection(tipo_usuario.toLowerCase())
        .doc(id_usuario)
        .set({
          'updatedOn':FieldValue.serverTimestamp(),
          'token': token}, //FieldValue.arrayUnion([token, FieldValue.serverTimestamp()])},
          SetOptions(merge: true)
          );
  }


  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) async {
      //print(token);
      await saveTokenToDatabase(token);
      tokenBy = token;
      _firebaseMessaging.onTokenRefresh.listen(saveTokenToDatabase);

    });
  }

  //###########################################################################1
  //############################################################################


  void setData() async{
    var sharedPreferences = await SharedPreferences.getInstance();

    setState(() {

      nombre = sharedPreferences.getString("nombre") ?? "Error";
      id_usuario = sharedPreferences.getString("idusuario") ?? "Error";
      tipo_usuario = sharedPreferences.getString("Tipo") ?? "Error";
    });

  }

  Future<void> _logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", false);
    Navigator.of(context).pushReplacementNamed('/login');
  }



  Widget getRow(String stringval, double textSize, double opacity){

      return Opacity(
        opacity: opacity,
        child:  Container(
          margin: const EdgeInsets.only(top: 20.0),
          child : Text(stringval ?? 'Error',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ) ;
    }


  @override
  Widget build(BuildContext context) {



    final lugaresbutton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: (MediaQuery.of(context).size.width/3.3),
         onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Lugares(),
                  settings: RouteSettings(
                    arguments: id_usuario
              )));
        },
        child: Text("Mis lugares",
            textAlign: TextAlign.center)
      ),
    );

    final buscarbutton = Material(
      
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      
      child: MaterialButton(
        
        minWidth: (MediaQuery.of(context).size.width/3.3),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=>MyMaps()));

        },
        child: Text("Buscar",
            textAlign: TextAlign.center
      )
      ),
    );

    final invitacionesbutton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      
      child: MaterialButton(
        
        minWidth: (MediaQuery.of(context).size.width/3.3),
        onPressed: (){
          //####################################################################
          //###################################################################1
          Navigator.pushNamed(context, '/notificacionesInquilino',
          arguments: messageTitle);
          //###################################################################1
          //####################################################################
        },
        child: Text("Invitaciones",
            textAlign: TextAlign.center
        )
      ),
    );



    return Scaffold(
      appBar: AppBar(
        title: Text('$nombre'),
        automaticallyImplyLeading: false,
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
      ),
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
                        key: UniqueKey(),
                      ),
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
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left:30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: lugaresbutton,//Icon(Icons.camera_alt),),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left:30),
              child:Align(
                alignment: Alignment.bottomCenter,
                child: buscarbutton,
          )),
          Padding(
              padding: EdgeInsets.only(left:30),
              child: Align(
                alignment: Alignment.bottomRight,
                child: invitacionesbutton,
          )),
        ],
      )
    );
  }

}

