import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Invitation extends StatefulWidget {
  @override
  _InvitationState createState() => _InvitationState();
}

class _InvitationState extends State<Invitation> with SingleTickerProviderStateMixin {

  void setData() async {
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
  Widget build(BuildContext context) {
    String title = 'Lista invitaciones';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container()
    );
  }
}