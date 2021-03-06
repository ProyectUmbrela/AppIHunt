import 'package:flutter/material.dart';
import 'rooms.dart';
import 'tenants.dart';
import 'invitation.dart';
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

  Future<void> _logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", false);
    Navigator.of(context).pushReplacementNamed('/login');
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
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.airline_seat_individual_suite)),
                Tab(icon: Icon(Icons.accessibility)),
                Tab(icon: Icon(Icons.card_giftcard))
              ],
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Text("Salir"),
                  new IconButton(
                    icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white),
                    onPressed: _logout,
                  )
                ],
              )
            ],
            title: Text('Hola $nombre'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.home),
              Rooms(),
              Tenants(),
              Invitations()
            ],
          ),
        ),
      ),
    );
  }
}
