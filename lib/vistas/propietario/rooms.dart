import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ihunt/providers/api.dart';
import 'registerRoom.dart';
import 'update_room.dart';
import 'details_room.dart';
import 'landlordView.dart';

import 'package:custom_switch/custom_switch.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class Room{
  String descripcion;
  String dimension;
  String direccion;
  String fecharegistro;
  String fechaupdate;
  String idhabitacion;
  String idpropietario;
  String idusuario;
  double precio;
  String servicios;
  int status;
  String terminos;
  int publicar;

  Room({
    this.descripcion,
    this.dimension,
    this.direccion,
    this.fecharegistro,
    this.fechaupdate,
    this.idhabitacion,
    this.idpropietario,
    this.idusuario,
    this.precio,
    this.servicios,
    this.status,
    this.terminos,
    this.publicar});
}

class _RoomsState extends State<Rooms> with SingleTickerProviderStateMixin {

  void setData() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      nombre = sharedPreferences.getString("nombre") ?? "Error";
      id = sharedPreferences.getString("idusuario") ?? "Error";
    });
  }
  // VARIABLES DE SESION
  String id;
  String nombre;
  @override
  void initState(){
    setData();
  }

  Map values_publ = {};
  Future getSpecie(String id_room) async {
    int check = await FirebaseFirestore.instance
        .collection('habitaciones')
        .doc(id_room)
        .get()
        .then((value) {
      return value['publicar']; // Access your after your get the data
    });

    if (check == 1){
      values_publ[id_room] = true;
    }
    if (check == 0){
      values_publ[id_room] = false;
    }
  }

  Future getRooms(id) async {
    Api _api = Api();

    final msg = jsonEncode({
      "usuario": id
    });

    var response = await _api.GetRooms(msg);
    var data = jsonDecode(response.body);
    List<Room> _rooms = [];

    if (response.statusCode == 200 || response.statusCode==201) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA;

      data['habitaciones'].forEach((room) async {

        getSpecie(room['idhabitacion']);
        _rooms.add(Room(
            descripcion: room['descripcion'],
            dimension: room['dimension'],
            direccion: room['direccion'],
            fecharegistro: room['fecharegistro'],
            fechaupdate: room['fechaupdate'],
            idhabitacion: room['idhabitacion'],
            idpropietario: room['idpropietario'],
            idusuario: room['idusuario'],
            precio: room['precio'],
            servicios: room['servicios'],
            status: room['estatus'],
            terminos: room['terminos']
        ));

      });
      print('############ ${values_publ}');
      return _rooms;
    } else {
      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
        print('ERROR EN GET ROOMS ${response.statusCode}');
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Lista de habitaciones';

    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          centerTitle: true
      ),
      body: FutureBuilder(
          future: getRooms(id),
          builder: (context, snapshot) {
            return snapshot.hasData ?
            Stack(
                children: <Widget> [ ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) =>
                              new DetailRoom(room:
                              {
                                'idhabitacion': snapshot.data[index].idhabitacion,
                                'descripcion': snapshot.data[index].descripcion,
                                'dimension': snapshot.data[index].dimension,
                                'direccion': snapshot.data[index].direccion,
                                'idpropietario': snapshot.data[index].idpropietario,
                                'precio': snapshot.data[index].precio,
                                'servicios': snapshot.data[index].servicios,
                                'status': snapshot.data[index].status,
                                'terminos': snapshot.data[index].terminos,
                              }
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shadowColor: Colors.deepPurpleAccent,
                          clipBehavior: Clip.antiAlias,
                          child: Material(
                            color: Colors.black12,
                            shadowColor: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(30.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.airline_seat_individual_suite),
                                  title: Text('Habitacion: ${snapshot.data[index].idhabitacion}'),
                                  subtitle: Text(
                                    'Inquilino: ${
                                        snapshot.data[index].idusuario==null?
                                            '':snapshot.data[index].idusuario
                                    }',
                                    style:
                                    TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Ocupada:',
                                              style: TextStyle(
                                                  color: Colors.black.withOpacity(0.6),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [ snapshot.data[index].status==1?
                                          Text(
                                            ' Sí',
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.normal),
                                          ):
                                          Text(
                                            ' No',
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: .0004, horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: 'Precio: \$', style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.bold)),
                                                    TextSpan(text: '${snapshot.data[index].precio}' , style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.normal)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: .0005, horizontal: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: 'Fecha Act: ', style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.bold)),
                                                    TextSpan(text: '${HttpDate.parse(snapshot.data[index].fechaupdate).day}/${HttpDate.parse(snapshot.data[index].fechaupdate).month}/${HttpDate.parse(snapshot.data[index].fechaupdate).year}' , style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.normal)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: Row(
                                    //padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Servicios: ',
                                              style: TextStyle(
                                                  color: Colors.black.withOpacity(0.6),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              snapshot.data[index].servicios,
                                              style: TextStyle(
                                                  color: Colors.black.withOpacity(0.6),
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    FlatButton(
                                      textColor: const Color(0xFF6200EE),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) =>
                                            new UpdateRoom(room:
                                            {
                                              'idhabitacion': snapshot.data[index].idhabitacion,
                                              'descripcion': snapshot.data[index].descripcion,
                                              'dimension': snapshot.data[index].dimension,
                                              'direccion': snapshot.data[index].direccion,
                                              'idpropietario': snapshot.data[index].idpropietario,
                                              'precio': snapshot.data[index].precio,
                                              'servicios': snapshot.data[index].servicios,
                                              'status': snapshot.data[index].status,
                                              'terminos': snapshot.data[index].terminos,
                                            }
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Editar'),
                                    ),
                                    Switch(
                                      value: values_publ[snapshot.data[index].idhabitacion],
                                      onChanged: (value) {
                                        setState(() {
                                          values_publ[snapshot.data[index].idhabitacion] = value;
                                        });

                                        var collection = FirebaseFirestore.instance.collection('habitaciones');
                                        collection
                                            .doc(snapshot.data[index].idhabitacion)
                                            .update({'publicar' :
                                              value==true? 1:0}) // <-- Updated data
                                            .then((_) => print('#################### Success'))
                                            .catchError((error) => print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Failed: $error'));
                                      },
                                    )
                                  ],
                                ),
                                //Image.asset('assets/card-sample-image.jpg'),
                                //Image.asset('assets/card-sample-image-2.jpg'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                ]
            )
                : Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new RegisterRoom(),
            ),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Registrar habitación"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.cyan,
      ),
    );
  }

}