import 'package:flutter/material.dart';
import 'package:ihunt/vistas/inquilino/detalles_invitacion.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificacionesInquilino extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationesInquilinoState();
  }
  
}

class NotificationesInquilinoState extends State<NotificacionesInquilino>{


  @override
  Widget build(BuildContext context) {

    final todo = ModalRoute.of(context).settings.arguments;

    var message;
    if (todo == "Empty!"){
      message = "No tienes nuevas invitaciones";
    }
    else{
      message = todo;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Invitaciones"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${message}",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>DetallesInvitacion()));
              },
              child: Text('Detalles'),
            ),
          ],
        ),
      ),
    );
  }
  
}