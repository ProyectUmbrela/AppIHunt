import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/vistas/inquilino/delete_account.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProfile extends StatefulWidget {

  @override
  _Profile createState() => _Profile();
}


class _Profile extends State<UserProfile> {

  var GlobalUserName;
  User _currentUser;
  String _nombreUser;
  String _correoUser;

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  Future retrieveData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    GlobalUserName = localStorage.getString('GlobalUserName');

    /*_currentUser = await FirebaseAuth.instance.currentUser;

    var snapShoot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    _nombreUser = snapShoot['nombre'];
    _correoUser = _currentUser.email;*/

  }

  Widget detallesRenta() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          /*DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Nombre',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),*/
          ListTile(
            title: Text(
              'Cuenta',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Notificaciones',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text(
              'Ayuda',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Update the state of the app.

            },
          ),
          ListTile(
            title: Text(
              'Salir',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {

            },
          ),
        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            //leading: Icon(Icons.map),
            title: Text('Nombre'),
          ),
          ListTile(
            //leading: Icon(Icons.photo_album),
            title: Text('Teléfono'),
          ),
          ListTile(
            //leading: Icon(Icons.phone),
            title: Text('Correo'),
          ),
          ListTile(
            title: Text(
              'Eliminar cuenta',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeleteAccount()),
              );
            },
          ),
        ],
      ),
    );
  }

  /*
  Future<List> getInvitaciones() async {

    var snapShoot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    //var _idUsuarioLive = snapShoot['usuario'];
    var tokenAuth = await _currentUser.getIdToken();

    //var result = await getInvitacionesRecientes(_idUsuarioLive, tokenAuth);
    return ['tokenAuth'];

  }

  Widget projectWidget() {

    return FutureBuilder(
      future: getInvitaciones(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          // Esperando la respuesta de la API
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Cargando...'),
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
                  "No tienes nuevas invitaciones, consulta el mapa para encontrar nuevas habitaciones",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        else  {
          // Informacion obtenida y con datos en el response
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              //Invitacion invitacion = snapshot.data[index];
              return ListView(
                children: <Widget>[
                  ListTile(
                    //leading: Icon(Icons.map),
                    title: Text('GlobalUserName'),
                  ),
                  ListTile(
                    //leading: Icon(Icons.photo_album),
                    title: Text('Teléfono'),
                  ),
                  ListTile(
                    //leading: Icon(Icons.phone),
                    title: Text('correo'),
                  ),
                  ListTile(
                    title: Text(
                      'Eliminar cuenta',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeleteAccount()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: projectWidget(),
    );
  }*/



}