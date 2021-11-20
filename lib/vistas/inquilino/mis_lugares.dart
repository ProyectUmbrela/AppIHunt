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
  String telefono;
  String costoRenta;
  String tiempoRenta;
  String terminosRenta;
  String direccion;
  String servicios;
  String descripcion;
  String fechaPago;


  Habitacion({
    this.name,
    this.estado,
    this.periodo,
    this.idhabitacion,
    this.telefono,
    this.costoRenta,
    this.tiempoRenta,
    this.terminosRenta,
    this.direccion,
    this.servicios,
    this.descripcion,
    this.fechaPago
  });


}


Future getHabitaciones(idUsuario) async {

  Map<int, String> meses = {
                            1:"Enero",
                            2:"Febrero",
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
    'usuario': idUsuario
  });

  var response = await _api.GetHabitaciones(body);
  List<Habitacion> habitaciones = [];
  int statusCode = response.statusCode;
  var resp = json.decode(response.body);

  if (statusCode == 201) {
    print("###################################");
    List actual = resp['habitacion_rentada'];
    if (actual.length > 0){
      print("HABITACION ACTUAL");
      for (int i=0; i < actual.length; i++){
        var habitacion = actual[i];

          var timeInit =  HttpDate.parse(habitacion['fechainicontrato']);
          //final mesInit = meses[timeInit.month];
          final periodo = "${meses[timeInit.month]} ${timeInit.year} - Actual";
          var diasPago =  HttpDate.parse(habitacion['fechapago']);

          final date2 = DateTime.now();

          var currentMonths = (date2.difference(timeInit).inDays)/30;
          var tiempoRentada = currentMonths.toInt().toString();
          //print("*****************MESES TRANSCURRIDOS: ${tiempoRentada}");
          /*
          *
            final birthday = DateTime(1967, 10, 12);
            final date2 = DateTime.now();
            final difference = date2.difference(birthday).inDays;
            *
          * */

          habitaciones.add(Habitacion(
              name: habitacion['nombre'],
              estado: "En Renta",
              periodo: periodo,
              idhabitacion: "${habitacion['idhabitacion']}",
              telefono: habitacion['telefono'],
              costoRenta: habitacion['precio'].toString(),
              tiempoRenta: tiempoRentada,
              terminosRenta: habitacion['terminos'],
              direccion: habitacion['direccion'],
              servicios: habitacion['servicios'],
              descripcion: habitacion['descripcion'],
              fechaPago: diasPago.day.toString()
          ));
          print("HABITACION ACTUAL AGREGADA A LA LISTA");
      }
    }

    /*else{
      print("No hay habitacion actual en renta");
    }*/


    List historial = resp['historial'];
    if (historial.length > 0){
      print("HISTORIAL DE HABITACIONES");
      for (int j=0; j < historial.length; j++){
        //print("leng: ${historial.length}");
        var habitacion = historial[j];

          var timeInit =  HttpDate.parse(habitacion['fechacontratoinit']);
          var timeFin =  HttpDate.parse(habitacion['fechacontratofin']);

          //final mesInit = meses[timeInit.month];
          //final mesFin = meses[timeFin.month];

          final periodo = "${meses[timeInit.month]} ${timeInit.year} - ${meses[timeFin.month]} ${timeFin.year}";

          habitaciones.add(
              Habitacion(
                  name: habitacion['nombre'],
                  estado: "Rentada",
                  periodo: periodo,
                  idhabitacion: "${habitacion['idhabitacion']}",
                  telefono: habitacion['telefono'],
                  costoRenta: "PRECIO DE RENTA",
                  tiempoRenta: habitacion['tiempoRentada'].toString(),
                  terminosRenta: habitacion['terminos'],
                  direccion: habitacion['direccion'],
                  servicios: habitacion['servicios'],
                  descripcion: habitacion['descripcion'],
                  fechaPago: "DIAS DE PAGO"
              )
          );
          //print("NEXT HABITACION");
      }
    }

    /*else{
      print("No hay historial de habitaciones en renta");
    }*/


    return habitaciones;
  }
}

/*_getHabitacionesList(idUsuario) async {

  return await getHabitaciones(idUsuario);
}*/


/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {


  Widget habitacionDetalles(habitacion) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: InkWell(
          onTap: ()=> _DetallesHabitacion(habitacion, context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    /*width: 1.0,
                    height: 1.0,*/
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
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      habitacion.periodo,
                      style: TextStyle(color: Colors.white, fontSize: 15),
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
    String idUsuario;
    //String nombre;
    //String tipo_usuario;
    var sharedPreferences = await SharedPreferences.getInstance();

    idUsuario = sharedPreferences.getString("idusuario") ?? "Error";
    //nombre = sharedPreferences.getString("nombre") ?? "Error";
    //tipo_usuario = sharedPreferences.getString("Tipo") ?? "Error";

    var result = await getHabitaciones(idUsuario);

    return result;

  }


  Widget projectWidget() {

    return FutureBuilder(
      future: getProjectDetails(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          // Esperando la respuesta de la API
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Cargando...'),
                ]
            ),
          );

        }
        else if(snapshot.hasData && snapshot.data.isEmpty) {
          // Informacion obtenida de la API pero esta vacio el response
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Aún no tienes habitaciones rentadas",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        else  {
          // Informacion obtenida y con datos en el response
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Habitacion habitacion = snapshot.data[index];
              return Column(
                children: <Widget>[
                  habitacionDetalles(habitacion)
                ],
              );
            },
          );
        }
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
  }
}

_DetallesHabitacion(habitacion, context) {

  Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => new DetallesHab(
          name: habitacion.name,
          estado: habitacion.estado,
          periodo: habitacion.periodo,
          idhabitacion: habitacion.idhabitacion,
          telefono: habitacion.telefono,
          costoRenta: habitacion.costoRenta,
          tiempoRenta: habitacion.tiempoRenta,
          terminosRenta: habitacion.terminosRenta,
          direccion: habitacion.direccion,
          servicios: habitacion.servicios,
          descripcion: habitacion.descripcion,
          fechaPago: habitacion.fechaPago,
      ),
  ));
  //print("HABITACION $habitacion");

}