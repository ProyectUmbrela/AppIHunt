import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/vistas/inquilino/notificaciones.dart';

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
  String enlace_aceptar;
  String enlace_rechazar;
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
    this.enlace_aceptar,
    this.enlace_rechazar,
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

  User _currentUser;
  String _idUsuario;


  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() async{
    _currentUser = FirebaseAuth.instance.currentUser;
  }


  Future getInvitacionesRecientes(_idUsuarioLive, tokenAuth)async {

    Api _api = Api();
    final body = jsonEncode({
      'usuario': _idUsuarioLive
    });

    var response = await _api.GetInvitacionesUsuarioView(body, tokenAuth);

    List<Invitacion> invitaciones = [];
    int statusCode = response.statusCode;
    var resp = json.decode(response.body);

    if (statusCode == 201) {
      List invitacion = resp['invitaciones'];
      if (invitacion.length > 0){
        for (int i=0; i < invitacion.length; i++){
          var current = invitacion[i];

          invitaciones.add(Invitacion(
              contrato: current['contrato'].toString(),
              descripcion: current['descripcion'],
              detalles: current['detalles'],
              dimension: current['dimension'],
              direccion: current['direccion'],
              enlace_aceptar: current['enlace_aceptar'],
              enlace_rechazar: current['enlace_rechazar'],
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

    var snapShoot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    var _idUsuarioLive = snapShoot['usuario'];
    String tokenAuth = await _currentUser.getIdToken();

    var result = await getInvitacionesRecientes(_idUsuarioLive, tokenAuth);
    return result;
  }


  Widget invitacionDetalles(invitacion) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: InkWell(
          onTap: ()=> _DetallesInivitacion(invitacion, context),
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
                  "No tienes nuevas invitaciones, consulta el mapa para encontrar nuevas habitaciones",
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
      body: projectWidget(),
    );
  }
}

_DetallesInivitacion(invitacion, context) {

  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => new DetallesInvitacion(
        contrato: invitacion.contrato,
        descripcion: invitacion.descripcion,
        detalles: invitacion.detalles,
        dimension: invitacion.dimension,
        direccion: invitacion.direccion,
        enlace_aceptar: invitacion.enlace_aceptar,
        enlace_rechazar: invitacion.enlace_rechazar,
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