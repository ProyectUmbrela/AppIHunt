import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/providers/provider.dart';

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
  String telefono;
  String nombre;

  Invitation({
    this.idusuario,
    this.idhabitacion,
    this.num_invitacion,
    this.fecha_envio,
    this.estatus,
    this.telefono,
    this.nombre
  });
}

class _InvitationsState extends State<Invitations> with SingleTickerProviderStateMixin {

  Future getAllInvitations() async{

    try{

      Api _api = Api();
      var snapShoot = await FirebaseFirestore.instance
          .collection(GlobalDataLandlord().userCollection)
          .doc(currentUser.uid)
          .get();
      var _userid = snapShoot['usuario'];
      String tokenAuth = await currentUser.getIdToken();

      final msg = jsonEncode({"usuario": _userid});

      var response = await _api.GetInvitations(msg, tokenAuth);
      var data = jsonDecode(response.body);
      print("###########################################################");
      print("###########################################################");
      print(data);
      print("###########################################################");
      print("###########################################################");

      List<Invitation> _invitations = [];



      if (response.statusCode == 201) {
        // CHECAR BIEN LOS CODIDOS DE RESPUESTA

        data["invitaciones"].forEach((invitation) {
          _invitations.add(Invitation(
              idusuario: invitation['idusuario'],
              idhabitacion: invitation['idhabitacion'],
              num_invitacion: invitation['num_invitacion'],
              fecha_envio: invitation['fecha_envio'],
              estatus: invitation['estatus'],
              telefono: invitation['telefono'],
              nombre: invitation['nombre']));
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
    }on Exception catch (exception) {
      final snackBar = SnackBar(
        content: const Text('Ocurrio un error!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    } catch (error) {
      return null;
    }
  }

  String status_map (int value){
    if(value == 0) return 'Pendiente';
    if(value == 1) return 'Rechazada';
    if(value == 2) return 'Aceptada';
  }

  void setData() async{
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }
  // VARIABLES DE SESION
  User currentUser;
  String id;
  String nombre;

  @override
  void initState(){
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //String title = 'Lista de invitaciones';

    return Scaffold(
      body: FutureBuilder(
          future: getAllInvitations(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              // Esperando la respuesta de la API
              if(snapshot.data == null && snapshot.connectionState == ConnectionState.done){
                return Center(
                  //child: Text("Algo salió mal en tu solicitud"),
                );
              }
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
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
                      "No tienes invitaciones recientes",
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
                      padding: const EdgeInsets.all(5),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shadowColor: Colors.deepPurpleAccent,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Material(
                            color: Colors.black12,
                            shadowColor: Colors.deepPurpleAccent,
                            //borderRadius: BorderRadius.circular(20.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: SizedBox(
                                    height: 60.0,
                                    width: 60.0,
                                    child: Center(child: Icon(Icons.people)),
                                  ),
                                  title: Text('Nombre: ${snapshot.data[index].nombre}'),
                                  subtitle: Text(
                                    'Usuario: ${snapshot.data[index].idusuario}',
                                    style:
                                    TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                /*ListTile(
                                  leading: Icon(Icons.airline_seat_individual_suite),
                                  title: Text('Usuario: ${snapshot.data[index].idusuario}'),
                                  subtitle: Text(
                                    'No. Invitacion: ${snapshot.data[index].num_invitacion}',
                                    style:
                                    TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),*/
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
                                                    TextSpan(text: 'Estado: ', style: TextStyle(
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
                                                    TextSpan(text: 'Tel: ', style: TextStyle(
                                                    //TextSpan(text: 'Tel. contacto: ', style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.bold)
                                                    ),
                                                    TextSpan(text: snapshot.data[index].telefono ,
                                                        style:
                                                        TextStyle(
                                                            color: Colors.black.withOpacity(0.6),
                                                            fontWeight: FontWeight.normal)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
              );
            }
          }
      ),
    );
  }
}
