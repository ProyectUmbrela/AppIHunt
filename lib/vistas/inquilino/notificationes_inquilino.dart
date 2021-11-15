import 'package:flutter/material.dart';

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
    print("===========> $todo");
    /*var message;
    if (todo == null){
      message = "Empty";
    }
    else{
      message = todo;
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Text("Invitaciones"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Inquilino",
            ),
            Text(
              "${todo}",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
  
}