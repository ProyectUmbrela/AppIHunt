import 'package:flutter/material.dart';
import 'package:ihunt/vistas/register.dart';
import 'rooms.dart';
import 'tenants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landlord extends StatefulWidget {
  @override
  _LandlordState createState() => _LandlordState();
}

class _LandlordState extends State<Landlord>
    with SingleTickerProviderStateMixin {

  // VARIABLES DE SESION
  String id_usuario;
  String nombre;

  @override
  void initState(){
    setData();
  }


  void setData() async{
    var sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      nombre = sharedPreferences.getString("nombre") ?? "Error";
      id_usuario = sharedPreferences.getString("idusuario") ?? "Error";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.airline_seat_individual_suite)),
                Tab(icon: Icon(Icons.accessibility)),
              ],
            ),
            title: Text('Hola $nombre'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.home),
              rooms(),
              Tenants(),
            ],
          ),
        ),
      ),
    );
  }
}
