import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class Notificaciones extends StatefulWidget{
  PushNotificaciones createState()=> PushNotificaciones();
}


class PushNotificaciones extends State<Notificaciones> {

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    /*FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("New message has been received");
        /*Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));*/
      }
    });*/

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


  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
    );
  }

}
