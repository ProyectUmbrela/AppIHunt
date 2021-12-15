import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ihunt/providers/api.dart';
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

    final msg = jsonEncode({
      "usuario": id
    });

    var response = await _api.GetTenants(msg);
    var data = jsonDecode(response.body);
    List<Tenant> _tenants = [];

    print("############################# responsecode inquilino ${response.statusCode}");
    if (response.statusCode == 201) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA

      data["inquilinos"].forEach((index, tenant) {
        print('****************key: $index , ${tenant['idpropietario']}');
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
      print('**************** FIN ${_tenants.length}');
      return _tenants;
    } else {
      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
        print(response.statusCode);
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }
    }
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

  Future deleteTenant(id, idhabitacion, idinquilino) async{

    Api _api = Api();

    final msg = jsonEncode({
      "idinquilino": idinquilino,
      "idhabitacion": idhabitacion,
      "idpropietario": id
    });

    var response = await _api.DeleteTenantPost(msg);
    var data = jsonDecode(response.body);

    //print("############################# responsecode ${response.statusCode}");
    if (response.statusCode == 201) {
      // CREAR UN REFRESH EN LA PAGINA
      debugPrint("############## INQUILINO ELIMINADO CORRECTAMENTE");


    } else {

      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
        print(response.statusCode);
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Lista de inquilinos';

    var _rooms;

    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          centerTitle: true
      ),
      body: FutureBuilder(
          future: getTenants(id),
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
                                            'inquilino: ',
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
                                          snapshot.data[index].idusuario,
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontWeight: FontWeight.normal),
                                        )
                                        ],
                                      ),
                                    ]),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton(
                                    textColor: const Color(0xFF6200EE),
                                    onPressed: () => deleteTenant(id, snapshot.data[index].idhabitacion, snapshot.data[index].idusuario),
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
              builder: (context) => new RegisterTenant(),
            ),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Registrar inquilino"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
