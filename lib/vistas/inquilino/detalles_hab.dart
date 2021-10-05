import 'package:flutter/material.dart';
import 'package:ihunt/vistas/inquilino/mis_lugares.dart';

class DetallesHab extends StatefulWidget {

  @override
  _DetallesHab createState() => _DetallesHab();
}
class _DetallesHab extends State<DetallesHab> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
              // icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Lugares())),
                }
            ),
            title: Text("Detalles de habitacion")
        )
    );
  }


}





