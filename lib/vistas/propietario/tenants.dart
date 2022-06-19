import 'dart:convert';
import 'dart:io';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihunt/providers/api.dart';
import 'registerTenants.dart';
import 'package:ihunt/providers/provider.dart';

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
  double precio;

  Tenant({
    this.fechafincontrato,
    this.fechainicontrato,
    this.fechamax,
    this.fechapago,
    this.id,
    this.idhabitacion,
    this.idpropietario,
    this.idusuario,
    this.precio});
}

class _TenantsState extends State<Tenants> with SingleTickerProviderStateMixin {

  Future getTenants(id) async{
    try{
      Api _api = Api();
      var snapShoot = await FirebaseFirestore.instance
          .collection(GlobalDataLandlord().userCollection)
          .doc(currentUser.uid)
          .get();
      var _userid = snapShoot['usuario'];
      String tokenAuth = await currentUser.getIdToken();

      final msg = jsonEncode({"usuario": _userid});

      var response = await _api.GetTenants(msg, tokenAuth);
      var data = jsonDecode(response.body);
      List<Tenant> _tenants = [];
      print("#####################################################");
      print("#####################################################");
      print(data);
      print("#####################################################");
      print("#####################################################");

      if (response.statusCode == 201) {
        data['inquilinos'].forEach((tenant) {
          _tenants.add(Tenant(
              fechafincontrato: tenant['fechafincontrato'],
              fechainicontrato: tenant['fechainicontrato'],
              fechamax: tenant['fechamax'],
              fechapago: tenant['fechapago'],
              id: tenant['id'],
              idhabitacion: tenant['idhabitacion'],
              idpropietario: tenant['idpropietario'],
              idusuario: tenant['nombre'],
              precio: tenant['precio']));
        });
        return _tenants;
      }
      if (response.statusCode == 403) {
        // este status es para caso sin inquilino
        return _tenants;
      } else {
        if (Platform.isAndroid) {
          //_materialAlertDialog(context, data['message'], 'Notificación');
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

    }
  }

  void setData() async{
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
      getFreeRooms();
      //print(rooms);
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

  Future getFreeRooms() async{
    try{
      Api _api = Api();
      var snapShoot = await FirebaseFirestore.instance
          .collection(GlobalDataLandlord().userCollection)
          .doc(currentUser.uid)
          .get();
      var _id = snapShoot['usuario'];
      String tokenAuth = await currentUser.getIdToken();

      final msg = jsonEncode({"usuario": _id});

      var response = await _api.GetRooms(msg, tokenAuth);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // CHECAR BIEN LOS CODIDOS DE RESPUESTA
        data['habitaciones'].forEach((room) {
          if (room['estatus'] == 0) {
            rooms.add(room['idhabitacion']);
          }
        });
        return rooms;
      } else {
        if (Platform.isAndroid) {
        } else if (Platform.isIOS) {
          //_cupertinoDialog(context, data['message'], 'Notificación');
        }
      }
    }on Exception catch (exception) {
      /*final snackBar = SnackBar(
        content: const Text('Ocurrio un error!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
      return null;
    } catch (error) {
      return null;
    }
  }

  /*Future deleteTenant(id, idhabitacion, idinquilino) async{
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
  }*/

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
          future: getTenants(id),
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
                      //Text('Cargando...'),
                    ],
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
                      "Sin inquilinos registrados",
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
                            /*
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
                            );*/
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
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: SizedBox(
                                      height: 60.0,
                                      width: 60.0,
                                      child: Center(child: Icon(Icons.airline_seat_individual_suite),),
                                    ),
                                    title: Text('Inquilino: ${snapshot.data[index].idusuario}'),
                                    subtitle: Text(
                                      'Habitación: ${snapshot.data[index].idhabitacion}',
                                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: .0004, horizontal: 5),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Dia de pago: ', style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.bold)),
                                                      TextSpan(text: '${HttpDate.parse(snapshot.data[index].fechapago).day} c/mes' , style: TextStyle(
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
                                                      TextSpan(text: 'Pago: \$ ', style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.bold)),
                                                      TextSpan(text: snapshot.data[index].precio.toString(), style: TextStyle(
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontWeight: FontWeight.normal)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: .0004, horizontal: 5),
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
                                                ),
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
                                                ),
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
                  ],
              );
            }
          }
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterTenant(rooms:{
                  'rooms': rooms
                }),
                settings: RouteSettings(name: '/tenants')),
          );

          /*Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) =>
              new RegisterTenant(rooms:{
                              'rooms': rooms
                            }
              ),
            ),
          );*/
        },
        icon: Icon(Icons.person),
        label: Text("Inquilino"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
