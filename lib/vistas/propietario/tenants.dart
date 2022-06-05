import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ihunt/providers/api.dart';
import 'details_tenant.dart';
import 'landlordView.dart';
import 'registerTenants.dart';

class Tenants extends StatefulWidget {
  @override
  _TenantsState createState() => _TenantsState();
}

class Tenant{
  String fechafincontrato;
  String fechainicontrato ;
  String fechamax;
  String fechapago;
  int id;
  String idhabitacion;
  String idpropietario;
  String idusuario;

  Tenant({
    this.fechafincontrato,
    this.fechainicontrato,
    this.fechamax,
    this.fechapago,
    this.id,
    this.idhabitacion,
    this.idpropietario,
    this.idusuario});
}

class _TenantsState extends State<Tenants> with SingleTickerProviderStateMixin {

  Future getTenants(id) async{
    Api _api = Api();

    var snapShoot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    var _id = snapShoot['usuario'];
    String tokenAuth = await currentUser.getIdToken();

    final msg = jsonEncode({
      "usuario": _id
    });

    var response = await _api.GetTenants(msg, tokenAuth);
    var data = jsonDecode(response.body);
    List<Tenant> _tenants = [];
    print(data);

    if (response.statusCode == 201) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA

      data['inquilinos'].forEach((tenant) {
        _tenants.add(Tenant(
            fechafincontrato: tenant['fechafincontrato'],
            fechainicontrato: tenant['fechainicontrato'] ,
            fechamax: tenant['fechamax'],
            fechapago: tenant['fechapago'],
            id: tenant['id'],
            idhabitacion: tenant['idhabitacion'],
            idpropietario: tenant['idpropietario'],
            idusuario: tenant['idusuario']
        ));
      });
      return _tenants;
    }
    if (response.statusCode == 403){ // este status es para caso sin inquilino
      return _tenants;
    }else {
      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }
    }
  }
  void setData() async{
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
      getRooms();
      print(rooms);
    });
  }

  // VARIABLES DE SESION
  User currentUser;
  String id;
  String nombre;
  List<String> rooms = [];

  @override
  void initState(){
    setData();
  }

  Future getRooms() async{
    Api _api = Api();

    var snapShoot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    var _id = snapShoot['usuario'];
    String tokenAuth = await currentUser.getIdToken();

    final msg = jsonEncode({
      "usuario": _id
    });

    var response = await _api.GetRooms(msg, tokenAuth);
    var data = jsonDecode(response.body);
    List<String> _rooms = [];

    if (response.statusCode == 200 || response.statusCode == 201) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA

      data['habitaciones'].forEach((room) {
        if (room['estatus']==0){
          rooms.add(room['idhabitacion']);
        }

      });
      return rooms;
    } else {
      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
        print(response.statusCode);
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }
    }
  }

  Future deleteTenant(id, idhabitacion, idinquilino) async{

    Api _api = Api();

    final msg = jsonEncode({
      "idinquilino": idinquilino,
      "idhabitacion": idhabitacion,
      "idpropietario": id
    });

    var response = await _api.DeleteTenantPost(msg);
    var data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode==200) {
      // CREAR UN REFRESH EN LA PAGINA
    } else {

      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    //String title = 'Lista de inquilinos';
    return Scaffold(
      body: FutureBuilder(
          future: getTenants(id),
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
              // Informacion obtenida de la API pero esta vacio el response
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "No tienes inquilinos registrados",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            else{
              return Stack(
                  children: <Widget> [ ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: const EdgeInsets.all(5),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                new DetailTenant(tenant:
                                {
                                  'fechafincontrato': snapshot.data[index].fechafincontrato,
                                  'fechainicontrato': snapshot.data[index].fechainicontrato,
                                  'fechamax': snapshot.data[index].fechamax,
                                  'fechapago': snapshot.data[index].fechapago,
                                  'id': snapshot.data[index].id,
                                  'idhabitacion': snapshot.data[index].idhabitacion,
                                  'idpropietario': snapshot.data[index].idpropietario,
                                  'idusuario': snapshot.data[index].idusuario
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
                              borderRadius: BorderRadius.circular(20.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.airline_seat_individual_suite),
                                    title: Text('Inquilino: ${snapshot.data[index].idusuario}'),
                                    subtitle: Text(
                                      'Habitacion: ${snapshot.data[index].idhabitacion}',
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
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: .0004, horizontal: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Fecha pago: ', style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.bold)),
                                                      TextSpan(text: '${HttpDate.parse(snapshot.data[index].fechapago).day} c/mes' , style: TextStyle(
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
                                                      TextSpan(text: 'Pago: \$', style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.bold)),
                                                      TextSpan(text: 'inserte' , style: TextStyle(
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: .0004, horizontal: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Inicio: ', style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.bold)),
                                                      TextSpan(text: '${HttpDate.parse(snapshot.data[index].fechainicontrato).day}/${HttpDate.parse(snapshot.data[index].fechainicontrato).month}/${HttpDate.parse(snapshot.data[index].fechainicontrato).year}' , style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.normal)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Fin: ', style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.bold)),
                                                      snapshot.data[index].fechafincontrato!=null?
                                                      TextSpan(text: '${HttpDate.parse(snapshot.data[index].fechafincontrato).day}/${HttpDate.parse(snapshot.data[index].fechafincontrato).month}/${HttpDate.parse(snapshot.data[index].fechafincontrato).year}' , style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.normal)) :
                                                      TextSpan(text: '' , style: TextStyle(
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
                                  //Image.asset('assets/card-sample-image.jpg'),
                                  //Image.asset('assets/card-sample-image-2.jpg'),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  ]
              );
            }






            /*
            return snapshot.hasData ?
            Stack(
                children: <Widget> [ ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: const EdgeInsets.all(5),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) =>
                              new DetailTenant(tenant:
                                {
                                'fechafincontrato': snapshot.data[index].fechafincontrato,
                                'fechainicontrato': snapshot.data[index].fechainicontrato,
                                'fechamax': snapshot.data[index].fechamax,
                                'fechapago': snapshot.data[index].fechapago,
                                'id': snapshot.data[index].id,
                                'idhabitacion': snapshot.data[index].idhabitacion,
                                'idpropietario': snapshot.data[index].idpropietario,
                                'idusuario': snapshot.data[index].idusuario
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
                            borderRadius: BorderRadius.circular(20.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.airline_seat_individual_suite),
                                  title: Text('Inquilino: ${snapshot.data[index].idusuario}'),
                                  subtitle: Text(
                                    'Habitacion: ${snapshot.data[index].idhabitacion}',
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
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: .0004, horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: 'Fecha pago: ', style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.bold)),
                                                    TextSpan(text: '${HttpDate.parse(snapshot.data[index].fechapago).day} c/mes' , style: TextStyle(
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
                                                    TextSpan(text: 'Pago: \$', style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.bold)),
                                                    TextSpan(text: 'inserte' , style: TextStyle(
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: .0004, horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: 'Inicio: ', style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.bold)),
                                                    TextSpan(text: '${HttpDate.parse(snapshot.data[index].fechainicontrato).day}/${HttpDate.parse(snapshot.data[index].fechainicontrato).month}/${HttpDate.parse(snapshot.data[index].fechainicontrato).year}' , style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.normal)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: 'Fin: ', style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.bold)),
                                                        snapshot.data[index].fechafincontrato!=null?
                                                          TextSpan(text: '${HttpDate.parse(snapshot.data[index].fechafincontrato).day}/${HttpDate.parse(snapshot.data[index].fechafincontrato).month}/${HttpDate.parse(snapshot.data[index].fechafincontrato).year}' , style: TextStyle(
                                                        color: Colors.black.withOpacity(0.6),
                                                        fontWeight: FontWeight.normal)) :
                                                        TextSpan(text: '' , style: TextStyle(
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
            );*/
          }
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) =>
              new RegisterTenant(rooms:{
                              'rooms': rooms
                            }
              ),
            ),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Inquilino"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
