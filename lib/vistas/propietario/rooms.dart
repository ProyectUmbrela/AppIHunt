import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/vistas/propietario/registerRoom.dart';
import 'package:ihunt/vistas/propietario/update_room.dart';
import 'package:shared_preferences/shared_preferences.dart';

class rooms extends StatefulWidget {
  @override
  _roomsState createState() => _roomsState();
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
    this.terminos});
}

class _roomsState extends State<rooms> with SingleTickerProviderStateMixin {

  void setData() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      nombre = sharedPreferences.getString("nombre") ?? "Error";
      id = sharedPreferences.getString("idusuario") ?? "Error";
    });
  }

  /**** VENTANAS DE DIALOGO PARA EL ERROR DE LA API O FORMULARIO****/
  Widget _buildActionButton(String title, Color color) {
    return FlatButton(
      child: Text(title),
      textColor: color,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _dialogTitle(String noty) {
    return Text(noty);
  }

  List<Widget> _buildActions() {
    return [_buildActionButton("Aceptar", Colors.blue)];
  }

  Widget _contentText(String texto) {
    return Text(texto);
  }

  Widget _showCupertinoDialog(String texto, noty) {
    return CupertinoAlertDialog(
      title: _dialogTitle(noty),
      content: _contentText(texto),
      actions: _buildActions(),
    );
  }

  Future<void> _cupertinoDialog(
      BuildContext context, String texto, String noty) async {
    return showCupertinoDialog<void>(
      context: context,
      builder: (_) => _showCupertinoDialog(texto, noty),
    );
  }

  Widget _showMaterialDialog(String texto, String noty) {
    return AlertDialog(
      title: _dialogTitle(noty),
      content: _contentText(texto),
      actions: _buildActions(),
    );
  }

  Future<void> _materialAlertDialog(
      BuildContext context, String texto, String noty) async {
    return showDialog<void>(
      context: context,
      builder: (_) => _showMaterialDialog(texto, noty),
    );
  }
  /***************************************************************************/

  Future getRooms(id) async{
    var sharedPreferences = await SharedPreferences.getInstance();
    nombre = sharedPreferences.getString("nombre") ?? "Error";

    //id = sharedPreferences.getString("idusuario") ?? "Error";
    Api _api = Api();

    final msg = jsonEncode({
      "usuario": id
    });

    var response = await _api.GetRooms(msg);
    var data = jsonDecode(response.body);
    List<Room> _rooms = [];

    print("############################# responsecode ${response.statusCode}");
    if (response.statusCode == 200) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA

      data.forEach((index, room) {
        //print('****************key: $index , ${room['idpropietario']}');
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
            status: room['status'],
            terminos: room['terminos']
        ));
      });
      print('**************** FIN ${_rooms.length}');
      return _rooms;
    } else {
      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
        print(response.statusCode);
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }
    }
  }


  // VARIABLES DE SESION
  String id;
  String nombre;
  List<Room> _rooms;

  @override
  void initState(){
    setData();
  }

  @override
  Widget build(BuildContext context) {

    String title = 'Lista de habitaciones';

    var _rooms;

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
                      padding: const EdgeInsets.all(5),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shadowColor: Colors.deepPurpleAccent,
                          clipBehavior: Clip.antiAlias,
                          child: Material(
                            color: Colors.black12,
                            shadowColor: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(20.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.airline_seat_individual_suite),
                                  title: Text('Habitacion: ${snapshot.data[index].idhabitacion}'),
                                  subtitle: Text(
                                    'Texto secundario',
                                    style:
                                    TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
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
                                              '  Sí',
                                              style: TextStyle(
                                                  color: Colors.black.withOpacity(0.6),
                                                  fontWeight: FontWeight.normal),
                                            ):
                                          Text(
                                            '  No',
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: 'Precio: ', style: TextStyle(
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
                                  alignment: MainAxisAlignment.spaceEvenly,
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
                                    FlatButton(
                                      textColor: const Color(0xFF6200EE),
                                      onPressed: snapshot.data[index].status==1?
                                          () {} :
                                          () {} ,
                                      child: const Text('Eliminar'),
                                    )
                                  ],
                                ),
                                //Image.asset('assets/card-sample-image.jpg'),
                                //Image.asset('assets/card-sample-image-2.jpg'),
                              ],
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
          label: Text("Agregar habitación"),
          foregroundColor: Colors.black,
          backgroundColor: Colors.cyan,
        ),
    );
  }
}
