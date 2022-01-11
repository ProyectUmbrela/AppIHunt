import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/vistas/inquilino/detalles_invitacion.dart';

class NotificacionesInquilino extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationesInquilinoState();
  }
  
}



class Invitacion {

  String contrato;
  String descripcion;
  String detalles;
  String dimension;
  String direccion;
  String enlace;
  String fechaEnvio;
  String fechaFin;
  String fechaInicio;
  String fechaPago;
  String idhabitacion;
  String idpropietario;
  String meses;
  String nombre;
  String plazo;
  String precio;
  String servicios;
  String telefono;
  String terminos;



  Invitacion({
    this.contrato,
    this.descripcion,
    this.detalles,
    this.dimension,
    this.direccion,
    this.enlace,
    this.fechaEnvio,
    this.fechaFin,
    this.fechaInicio,
    this.fechaPago,
    this.idhabitacion,
    this.idpropietario,
    this.meses,
    this.nombre,
    this.plazo,
    this.precio,
    this.servicios,
    this.telefono,
    this.terminos
  });


}



class NotificationesInquilinoState extends State<NotificacionesInquilino>{


  Future getInvitacionesRecientes(idUsuario) async {
    Api _api = Api();
    final body = jsonEncode({
      'usuario': idUsuario
    });
    print("################## usuario : ${idUsuario}");
    var response = await _api.GetInvitacionesRecientes(body);

    List<Invitacion> invitaciones = [];
    int statusCode = response.statusCode;
    var resp = json.decode(response.body);

    print("==================> ${statusCode}");
    if (statusCode == 201) {

      List invitacion = resp['invitaciones'];
      print("2 ==================> ${invitacion.length}");
      if (invitacion.length > 0){
        print("2 ==================> ${invitacion.length}");
        for (int i=0; i < invitacion.length; i++){
          var current = invitacion[i];

          //print("################################################");
          //print(current);
          //print("################################################");

          invitaciones.add(Invitacion(
              contrato: current['contrato'].toString(),
              descripcion: current['descripcion'],
              detalles: current['detalles'],
              dimension: current['dimension'],
              direccion: current['direccion'],
              enlace: current['enlace'],
              fechaEnvio: current['fecha_envio'].toString(),
              fechaFin: current['fecha_fin'].toString(),
              fechaInicio: current['fecha_inicio'].toString(),
              fechaPago: current['fecha_pago'].toString(),
              idhabitacion: current['idhabitacion'],
              idpropietario: current['idpropietario'],
              meses: current['meses'].toString(),
              nombre: current['nombre'],
              plazo: current['plazo'].toString(),
              precio: current['precio'].toString(),
              servicios: current['servicios'],
              telefono: current['telefono'],
              terminos: current['terminos']
          ));
        }
      }

      return invitaciones;

    }



  }

  Future getInvitaciones() async {
    String idUsuario;
    //String nombre;
    //String tipo_usuario;
    var sharedPreferences = await SharedPreferences.getInstance();

    idUsuario = sharedPreferences.getString("idusuario") ?? "Error";
    //nombre = sharedPreferences.getString("nombre") ?? "Error";
    //tipo_usuario = sharedPreferences.getString("Tipo") ?? "Error";

    var result = await getInvitacionesRecientes(idUsuario);
    return result;

  }


  Widget invitacionDetalles(invitacion) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: InkWell(
          onTap: ()=>_DetallesInivitacion(invitacion, context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: new BoxDecoration(shape: BoxShape.circle),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      invitacion.nombre,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      invitacion.fechaEnvio,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),/*
                    Text(
                      invitacion.periodo,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )*/
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget projectWidget() {

    return FutureBuilder(
      future: getInvitaciones(),
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
              Invitacion invitacion = snapshot.data[index];
              return Column(
                children: <Widget>[
                  invitacionDetalles(invitacion)
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
        title: Text('Invitaciones'),
        automaticallyImplyLeading: false,
      ),
      body: projectWidget(),
    );
  }
    /*
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
  }*/


}


_DetallesInivitacion(invitacion, context) {

  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => new DetallesInvitacion(
        contrato: invitacion.contrato,
        descripcion: invitacion.descripcion,
        detalles: invitacion.detalles,
        dimension: invitacion.dimension,
        direccion: invitacion.direccion,
        enlace: invitacion.enlace,
        fechaEnvio: invitacion.fechaEnvio,
        fechaFin: invitacion.fechaFin,
        fechaInicio: invitacion.fechaInicio,
        fechaPago: invitacion.fechaPago,
        idhabitacion: invitacion.idhabitacion,
        idpropietario: invitacion.idpropietario,
        meses: invitacion.meses,
        nombre: invitacion.nombre,
        plazo: invitacion.plazo,
        precio: invitacion.precio,
        servicios: invitacion.servicios,
        telefono: invitacion.telefono,
        terminos: invitacion.terminos
    )
  ));

}