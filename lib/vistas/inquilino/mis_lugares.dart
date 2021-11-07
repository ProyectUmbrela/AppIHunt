import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:ihunt/vistas/inquilino/detalles_hab.dart';
import 'package:shared_preferences/shared_preferences.dart';

//permissions
//import 'package:permission_handler/permission_handler.dart';
//import 'package:android_intent/android_intent.dart';


import 'package:ihunt/providers/api.dart';
import 'dart:async';

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

  Habitacion({
    this.name,
    this.estado,
    this.periodo,
    this.idhabitacion});
}


Future getHabitaciones(id_usuario) async {

  Map<int, String> meses = {
                            1:"Enero",
                            2:"Febbrero",
                            3:"Marzo",
                            4:"Abril",
                            5:"Mayo",
                            6:"Junio",
                            7:"Julio",
                            8:"Agosto",
                            9:"Septiembre",
                            10:"Octubre",
                            11:"Noviembre",
                            12:"Diciembre"};
  Api _api = Api();
  final body = jsonEncode({
    'usuario': id_usuario
  });

  var response = await _api.GetHabitaciones(body);
  List<Habitacion> habitaciones = [];
  int statusCode = response.statusCode;
  var resp = json.decode(response.body);

  if (statusCode == 201) {
    print("###################################");
    List actual = resp['habitacion_rentada'];
    if (actual.length > 0){

      for (int i=0; i < actual.length; i++){
        var habitacion = actual[i];

          var timeInit =  HttpDate.parse(habitacion['fechainicontrato']);
          final mesInit = meses[timeInit.month];

          final periodo = "${meses[timeInit.month]} ${timeInit.year} - Actual";
          //print("PERIODO = ${periodo}");
          //print("ID_HABITACION: ${habitacion['idhabitacion']}");

          habitaciones.add(Habitacion(
              name: habitacion['nombre'],
              estado: "En Renta",
              periodo: periodo,
              idhabitacion: "${habitacion['idhabitacion']}"));
      }
    }

    else{
      print("No hay habitacion actual en renta");
    }


    List historial = resp['historial'];
    if (historial.length > 0){
      print("HISTORIAL DE HABITACIONES");
      for (int j=0; j < historial.length; j++){
        print("leng: ${historial.length}");
        var habitacion = historial[j];

          var timeInit =  HttpDate.parse(habitacion['fechacontratoinit']);
          var timeFin =  HttpDate.parse(habitacion['fechacontratofin']);

          final mesInit = meses[timeInit.month];
          final mesFin = meses[timeFin.month];

          final periodo = "${meses[timeInit.month]} ${timeInit.year} - ${meses[timeFin.month]} ${timeFin.year}";
          print("PERIODO = ${periodo}");
          print("ID_HABITACION: ${habitacion['idhabitacion']}");

          habitaciones.add(Habitacion(
              name: habitacion['nombre'],
              estado: "Rentada",
              periodo: periodo,
              idhabitacion: "${habitacion['idhabitacion']}"));

      }
    }
    else{
      print("No hay historial de habitaciones en renta");
    }
    return habitaciones;
  }
}

_getHabitacionesList(id_usuario) async {

  return await getHabitaciones(id_usuario);
}


/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  //@override
  Widget habitacionDetails(habitacion) {
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


  Future getProjectDetails() async {
    String id_usuario;
    //String nombre;
    //String tipo_usuario;
    var sharedPreferences = await SharedPreferences.getInstance();

    id_usuario = sharedPreferences.getString("idusuario") ?? "Error";
    //nombre = sharedPreferences.getString("nombre") ?? "Error";
    //tipo_usuario = sharedPreferences.getString("Tipo") ?? "Error";

    var result = await getHabitaciones(id_usuario);

    return result;

  }


  Widget projectWidget() {
    return FutureBuilder(
      future: getProjectDetails(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Habitacion habitacion = snapshot.data[index];
                  return Column(
                    children: <Widget>[
                      habitacionDetails(habitacion)
                    ],
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis habitaciones'),
      ),

      body: projectWidget(),
    );



    /*return Scaffold(
      appBar: AppBar(
        title: Text("Mis habitaciones rentadas"),
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
      );*/
  }

}

_testClicked(idhabitacion, context) {

  Navigator.of(context).push(MaterialPageRoute(
      builder: (context)=>DetallesHab(),
      settings: RouteSettings(
        arguments: {0: "1"},
      )
      ));
  print("HABITACION $idhabitacion");

}