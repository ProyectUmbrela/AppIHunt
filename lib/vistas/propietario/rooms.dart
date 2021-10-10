import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/vistas/propietario/registerRoom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class rooms extends StatefulWidget {
  @override
  _roomsState createState() => _roomsState();
}

class _roomsState extends State<rooms> with SingleTickerProviderStateMixin {

  void setData() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      nombre = sharedPreferences.getString("nombre") ?? "Error";
      id = sharedPreferences.getString("idusuario") ?? "Error";
      //getRooms(id);
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

  getRooms(id) async{
    Api _api = Api();

    final msg = jsonEncode({
      "usuario": id
    });
    print(msg);

    var response = await _api.GetRooms(msg);
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA
      debugPrint("Rooms get");
      print(data);

      setState(() {
        rooms_ = data;
        flag_room = 1;
      });
    } else {
      setState(() {
        rooms_ = data;
        flag_room = 0;
      });
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
  Map<dynamic, dynamic> rooms_;
  int flag_room;

  @override
  void initState(){
    setData();
  }

  @override
  Widget build(BuildContext context) {

    String title = 'Lista de habitaciones';

    final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F'];

    //print("################ ${rooms_.length}");

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget> [ ListView.builder(
              itemCount: entries.length,
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
                          title: Text('Habitacion ${entries[index]}'),
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
                                  children: [
                                    Text(
                                      '  sí',
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
                                            TextSpan(text: '${entries[index]}' , style: TextStyle(
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
                                      ' AGUA, LUZ, INTERNET, ETC.',
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
                                // Perform some action
                              },
                              child: const Text('Editar'),
                            ),
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
