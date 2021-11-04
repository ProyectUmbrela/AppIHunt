import 'package:flutter/material.dart';


class DetallesHab extends StatefulWidget {

  @override
  _DetallesHab createState() => _DetallesHab();
}




class _DetallesHab extends State<DetallesHab> {



  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context).settings.arguments;

    print("=======> ${todo}");
    return Scaffold(
        appBar: AppBar(
            title: Text("Detalles de habitacion")
        )
    );
  }


}





