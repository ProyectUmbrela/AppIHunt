import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {

  @override
  _Profile createState() => _Profile();
}


class _Profile extends State<UserProfile> {



  Widget detallesRenta() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
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
          ),
          ListTile(
            title: Text(
              'Cuenta',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Update the state of the app.
              // ...UserProfile()

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
            title: Text('Correo electrónico'),
          ),
          ListTile(
            title: Text(
              'Eliminar cuenta',

            ),
            onTap: () {


            },
          ),
        ],
      ),
    );
  }


}