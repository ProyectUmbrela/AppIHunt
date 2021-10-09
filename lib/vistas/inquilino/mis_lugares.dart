import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ihunt/vistas/inquilino/detalles_hab.dart';
import 'package:ihunt/vistas/userView.dart';
import 'package:shared_preferences/shared_preferences.dart';

//permissions
//import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent/android_intent.dart';



/// This is the main application widget.
class Lugares extends StatelessWidget {
  static const String _title = 'Mis lugares';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

// https://medium.com/dlt-labs-publication/how-to-build-a-flutter-card-list-in-less-than-10-minutes-9839f79a6c08
/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget() : super();
 
  @override
  createState() => _MyStatefulWidgetState();
}

class Habitacion {
  String name;
  String estado;
  String periodo;
  String idhabitacion;

  Habitacion({this.name, this.estado,this.periodo, this.idhabitacion});

}


/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Habitacion> habitaciones = [
    Habitacion(name: "Fredy Marin", estado: "En Rentada", periodo: "Ene - Actual", idhabitacion: "A"),
    Habitacion(name: "Anakin Walker", estado: "Rentada", periodo: "Abr - May", idhabitacion: "B"),
    Habitacion(name: "Anakin Walker", estado: "Rentada", periodo: "Abr - May", idhabitacion: "C"),
    Habitacion(name: "Anakin Walker", estado: "Rentada", periodo: "Abr - May", idhabitacion: "D"),
    Habitacion(name: "Anakin Walker", estado: "Rentada", periodo: "Abr - May", idhabitacion: "E"),
    Habitacion(name: "Anakin Walker", estado: "Rentada", periodo: "Abr - May", idhabitacion: "F"),
    Habitacion(name: "Anakin Walker", estado: "Rentada", periodo: "Abr - May", idhabitacion: "G"),
    Habitacion(name: "Anakin Walker", estado: "Rentada", periodo: "Abr - May", idhabitacion: "H"),
    Habitacion(name: "Anakin Walker", estado: "Rentada", periodo: "Abr - May", idhabitacion: "I"),
    Habitacion(name: "Alfonso Suarez", estado: "Rentada", periodo: "Jun - Ago", idhabitacion: "J")
  ];

  //@override
  Widget habitaciondetail(habitacion) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: InkWell(
          onTap: ()=> _testClicked(habitacion.idhabitacion, context),
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(shape: BoxShape.circle),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: <Widget>[
                  Text(
                    habitacion.name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    habitacion.estado,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    habitacion.periodo,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
         // icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserView()))
            }
        ), 
        title: Text("Volver"),
      ),
      //backgroundColor: Colors.grey[900],

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    /*children: <Widget>[
                      Icon(Icons.menu, size: 35, color: Colors.white),
                      Text('Notifications',
                        style: TextStyle (
                          color: Colors.white,
                          fontSize: 25
                        ),
                      ),
                      Icon(Icons.notifications_none, size: 35, color: Colors.white)
                    ],*/
                  ),
                  Column(
                    children: habitaciones.map((p) {
                      return habitaciondetail(p);
                    }).toList()
                  )
                ],
              
          )),
      );
  }

}

_testClicked(idhabitacion, context) {
  Navigator.of(context).pop();
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetallesHab()));
  print("HABITACION $idhabitacion");

}