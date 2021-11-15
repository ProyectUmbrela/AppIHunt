import 'package:flutter/material.dart';


/*class NotificacionesPropietario extends StatefulWidget{
  NotificacionesProp createState()=> NotificacionesProp();
}*/


class NotificacionesPropietario extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificacionesPropState();
  }

}





class NotificacionesPropState extends State<NotificacionesPropietario> {
  //const NotificacionesPropietario({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final todo = ModalRoute.of(context).settings.arguments;
    /*print("VALOR: {$todo}");
    var message;

    if (todo == null){
      message = 'Empty';
    }
    else{
      message = todo;
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Propietario",
            ),
            Text(
              "$todo",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
