import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/vistas/inquilino/delete_account.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProfile extends StatefulWidget {

  @override
  _Profile createState() => _Profile();
}

class ProjectModel {

  String nameUser;
  String mailUser;
  String phoneUser;


  ProjectModel({
    this.nameUser,
    this.mailUser,
    this.phoneUser,
  });
}

class _Profile extends State<UserProfile> {

  User _currentUser;

  Future getProjectDetails() async {

    _currentUser = await FirebaseAuth.instance.currentUser;

    var snapShoot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    return [ProjectModel(nameUser: snapShoot['nombre'], mailUser: _currentUser.email, phoneUser: "telefono")];

  }

  Widget projectWidget() {

    return FutureBuilder(
      future: getProjectDetails(),
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
        else{
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              ProjectModel project = snapshot.data[index];
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(project.nameUser),
                  ),
                  ListTile(
                    title: Text('Teléfono'),
                  ),
                  ListTile(
                    title: Text(project.mailUser),
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
                  )
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
      appBar: AppBar(
        title: Text('Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: projectWidget(),
    );
  }

}