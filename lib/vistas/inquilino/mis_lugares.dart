import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/vistas/userView.dart';
import 'package:shared_preferences/shared_preferences.dart';



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

  Habitacion({this.name, this.estado});

}


/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Habitacion> habitaciones = [
    Habitacion(name: "Nombre propietario 1", estado: "Rentada"),
    Habitacion(name: "Nombre propietario 2", estado: "Rentada2"),
    Habitacion(name: "Nombre propietario 3", estado: "Rentada3")
  ];



  //@override
  Widget habitaciondetail(habitacion) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      
      child: Card(
        color: Colors.grey[800],
        child: InkWell(
          onTap: ()=> _testClicked(),
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


  Future backToUser() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => User()),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Volver",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            backToUser();
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThirdScreen()),
            );
            */
          },
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
        child: Column(
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
        ),
      ),
    );
  }

}

_testClicked() {
  print("object 1");

}