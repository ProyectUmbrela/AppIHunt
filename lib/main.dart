//import 'dart:js';
//import 'package:js/js.dart';

import 'package:flutter/material.dart';
import 'vistas/propietario/registerRoom.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


//Permisos de localizacion
//import 'package:location_permissions/location_permissions.dart';

// Vistas de inquilino
import 'package:ihunt/vistas/userView.dart'; // principal
import 'package:ihunt/vistas/inquilino/mis_lugares.dart';
import 'package:ihunt/vistas/inquilino/mapa.dart';

// VISTA PROPIETARIO
import 'vistas/propietario/landlordView.dart';

// IMPORTAR VISTAS
import 'vistas/mainscreen.dart';
import 'vistas/register.dart';
import 'vistas/login.dart';




Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = (prefs.getBool('isLogged') ?? false) ;

  var home;
  if(isLogged)
    home = MapSample();//User();
  else
    home = LoginPage() ;

  runApp(MaterialApp(
    title: 'i-hunt',
    home: LoginPage(),
    routes: {
      '/login' : (context) => LoginPage(),
      '/user' : (context) => User(),
      '/landlord': (context) => Landlord(),
      '/register' : (context) => Register(),
      '/lugares': (context) => Lugares(),
      '/mapa' : (context) => MapSample(),
      '/registerRoom' : (context) => RegisterRoom(),
    },

  ));

}
