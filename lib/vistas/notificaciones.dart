import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihunt/vistas/inquilino/notificationes_inquilino.dart';


class Notificaciones extends StatefulWidget{

  PushNotificaciones createState()=> PushNotificaciones();


}



class PushNotificaciones extends State<Notificaciones> {


  String id_usuario;
  String nombre;
  String tipo_usuario;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String messageTitle = "Empty";
  String notificationAlert = "Alert";



  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token){
      print(token);

      if (tipo_usuario == 'Usuario') {
        Navigator.pushNamed(context, '/NotificationesInquilino',
            arguments: messageTitle,
            );
      }

      else if (tipo_usuario == 'Propietario'){
        Navigator.pushNamed(context, '/NotificationesPropietario',
            arguments: RouteSettings(
              arguments: messageTitle,
            ));
      }

      else{
        Navigator.pushNamed(context, '/IHunt',
            arguments: RouteSettings(
              arguments: messageTitle,
            ));
      }



    });
  }

  void setData() async{
    var sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      nombre = sharedPreferences.getString("nombre") ?? "Error";
      id_usuario = sharedPreferences.getString("idusuario") ?? "Error";
      tipo_usuario = sharedPreferences.getString("Tipo") ?? "Error";
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setData();
    _setFCMToken();


    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      setState(() {
        messageTitle = event.notification.title;
        notificationAlert = "New Notification Alert";
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage  event) {
      setState(() {
        messageTitle = event.notification.title;
        notificationAlert = "Application opened from Notification";
      });
    });

    print("MENSAGE: {$messageTitle}");

  }

  void _setFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /*FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("New message has been received");
        /*Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));*/
      }
    });*/
    print("Loggeado como ================> $tipo_usuario");
    //tipo_usuario = 'Usuario';
    //var mensage = await messageTitle;

    /*
    messaging.getInitialMessage().then((RemoteMessage message) {

      if (tipo_usuario == 'Propietario'){
        Navigator.pushNamed(context, '/NotificationesPropietario',
        arguments: RouteSettings(
          arguments: mensage,
        ));
      }


      else if (tipo_usuario == 'Usuario') {
        /*Navigator.pushNamed(context, '/NotificationesInquilino');*/
        Navigator.pushNamed(context, '/NotificationesInquilino',
            arguments: RouteSettings(
              arguments: mensage,
            ));
        }
    });*/
  }




  @override
  Widget build(BuildContext context) {

    firebaseCloudMessaging_Listeners();

    return Scaffold(
      /*
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              notificationAlert,
            ),
            Text(
              messageTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    */);
  }

}
