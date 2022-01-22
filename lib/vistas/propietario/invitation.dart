import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ihunt/providers/api.dart';
import 'registerTenants.dart';

class Invitations extends StatefulWidget {
  @override
  _InvitationsState createState() => _InvitationsState();
}

class Invitation{
  String idusuario;
  String idhabitacion;
  int num_invitacion;
  String fecha_envio;
  int estatus;

  Invitation({
    this.idusuario,
    this.idhabitacion,
    this.num_invitacion,
    this.fecha_envio,
    this.estatus});
}

class _InvitationsState extends State<Invitations> with SingleTickerProviderStateMixin {

  Future getInvitations(id) async{
    Api _api = Api();

    final msg = jsonEncode({
      "usuario": id
    });

    var response = await _api.GetInvitations(msg);
    var data = jsonDecode(response.body);
    List<Invitation> _invitations = [];

    if (response.statusCode == 201) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA

      data["invitaciones"].forEach((invitation) {
        _invitations.add(Invitation(
            idusuario: invitation['idusuario'],
            idhabitacion: invitation['idhabitacion'],
            num_invitacion: invitation['num_invitacion'],
            fecha_envio: invitation['fecha_envio'],
            estatus: invitation['estatus']
        ));
      });
      return _invitations;
    } else {
      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
        print(response.statusCode);
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }
    }
  }

  String status_map (int value){
    if(value == 0) return 'Pendiente';
    if(value == 1) return 'Rechazada';
    if(value == 2) return 'Aceptada';
  }

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

  @override
  Widget build(BuildContext context) {
    String title = 'Lista de invitaciones';

    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          centerTitle: true
      ),
      body: FutureBuilder(
          future: getInvitations(id),
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
                                title: Text('Usuario: ${snapshot.data[index].idusuario}'),
                                subtitle: Text(
                                  'No. Invitacion: ${snapshot.data[index].num_invitacion}',
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
                                            'Habitación: ',
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
                                            snapshot.data[index].idhabitacion,
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.normal),
                                          )
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
                                                  TextSpan(text: 'Estatus: ', style: TextStyle(
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold)
                                                  ),
                                                  TextSpan(text: status_map(snapshot.data[index].estatus) ,
                                                      style:
                                                      TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.normal)
                                                  ),
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
                                            'Enviada: ',
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('${HttpDate.parse(snapshot.data[index].fecha_envio).day}/${HttpDate.parse(snapshot.data[index].fecha_envio).month}/${HttpDate.parse(snapshot.data[index].fecha_envio).year}',
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(text: 'Telefono: ', style: TextStyle(
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold)
                                                  ),
                                                  TextSpan(text: 'xxxxxxxxxx' ,
                                                      style:
                                                      TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.normal)
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                              )
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
    );
  }
}
