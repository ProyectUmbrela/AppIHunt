import 'dart:convert';
import 'dart:io';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ihunt/providers/api.dart';
import 'registerRoom.dart';
import 'update_room.dart';
//import 'details_room.dart';
//import 'landlordView.dart';

//import 'package:custom_switch/custom_switch.dart';

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
  bool publicar;
  String foto;

  Room({
    this.foto,
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
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }
  // VARIABLES DE SESION
  User currentUser;

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
          //print("############ ${value['publicar']}");
          return value['publicar']; //
          });

    //if (check == 1){
      //values_publ[id_room] = true;
   // }
    //else if (check == 0){
      //values_publ[id_room] = false;
    //}
    ////print('###################### CHECK: ${check}');
    return check;
  }

  Future getRooms() async {
    Api _api = Api();

    var snapShoot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    var _userid = snapShoot['usuario'];
    String tokenAuth = await currentUser.getIdToken();

    final msg = jsonEncode({
      "usuario": _userid
    });


    var response = await _api.GetRooms(msg, tokenAuth);
    var data = jsonDecode(response.body);
    List<Room> _rooms = [];

    print("#########################################################");
    print("#########################################################");
    print(data);
    print("${response.statusCode }");
    print("#########################################################");
    print("#########################################################");

    if (response.statusCode == 200 || response.statusCode == 201) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA;
      Map<String, bool> newcontent = {};

      getValue() async{
        for(int i = 0; i < data['habitaciones'].length; i++){
          var document = data['habitaciones'][i]['idhabitacion'] + '_${data['habitaciones'][i]['idpropietario']}';
          int result = await getSpecie(document);
          newcontent["${data['habitaciones'][i]['idhabitacion']}"] = result == 1 ? true : false;
        }
      }
      // getting status of room
      await getValue();

      data['habitaciones'].forEach((room) {
        _rooms.add(Room(
            publicar: newcontent[room['idhabitacion']],
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

      return _rooms;

    } else {
      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
        print('ERROR EN GET ROOMS ${response.statusCode}');
      } else if (Platform.isIOS) {
        print('ERROR EN GET ROOMS ${response.statusCode}');
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }
    }
  }

  Future getAnImage(idhabitacion) async {

    var snapShoot = await FirebaseFirestore
        .instance
        .collection('habitaciones')
        .doc(idhabitacion)
        .get();

    return snapShoot.data();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
          future: getRooms(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              // Esperando la respuesta de la API
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      //Text('Cargando...'),
                    ]
                ),
              );
            }
            else if(snapshot.hasData && snapshot.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "No tienes habitaciones registradas",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            else{
              return Stack(
                  children: <Widget> [
                    ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            /*Navigator.push(
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
                            );*/
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                new UpdateRoom(room:
                                  {
                                    'foto': snapshot.data[index].foto,
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Material(
                              color: Colors.black12,
                              shadowColor: Colors.deepPurpleAccent,
                              //borderRadius: BorderRadius.circular(10.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.airline_seat_individual_suite),
                                    /*leading: SizedBox(
                                      //height: 100.0,
                                      //width: 100.0,
                                      child: Image.memory(Base64Decoder().convert(snapshot.data[index].foto), fit: BoxFit.cover),
                                    ),*/
                                    title: Text('Habitacion: ${snapshot.data[index].idhabitacion}'),
                                    subtitle: Text(
                                      'Inquilino: ${
                                          snapshot.data[index].idusuario == null ? 'No' : snapshot.data[index].idusuario
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
                                            children: [ snapshot.data[index].status == 1 ?
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
                                                ),
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
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
                                        ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      ButtonBar(
                                        alignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Publicar: ',
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Switch(
                                            value: snapshot.data[index].publicar,//values_publ[snapshot.data[index].idhabitacion],
                                            onChanged: (value) {
                                              setState(() {
                                                //values_publ[snapshot.data[index].idhabitacion] = value;
                                              });
                                              var collection = FirebaseFirestore.instance.collection('habitaciones');
                                              collection.doc(snapshot.data[index].idhabitacion + '_${snapshot.data[index].idpropietario}')
                                                  .update({'publicar' : value == true ? 1 : 0}) // <-- Updated data
                                                  .then((_) => _showDialog(2, 'Publicación pausada') )
                                                  .catchError((error) => _showDialog(22, 'Ocurrio un error'));
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
              );
            }
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
        icon: Icon(Icons.airline_seat_individual_suite),
        label: Text("Habitación"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue//Color(0xff01A0C7),//Colors.cyan,
      ),
    );
  }

  void _showDialog(seconds, message) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        Future.delayed(Duration(seconds: seconds), () {
        });
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

}