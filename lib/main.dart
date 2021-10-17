//import 'dart:js';
import 'package:flutter/material.dart';
import 'vistas/propietario/registerRoom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// Vistas de inquilino
import 'package:ihunt/vistas/userView.dart'; // principal
import 'package:ihunt/vistas/inquilino/mis_lugares.dart';
import 'package:ihunt/vistas/inquilino/test_map.dart';
import 'package:ihunt/vistas/inquilino/detalles_hab.dart';


// VISTA PROPIETARIO
import 'vistas/propietario/landlordView.dart';

// IMPORTAR VISTAS
import 'vistas/mainscreen.dart';
import 'vistas/register.dart';
import 'vistas/login.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init the firebase system
  await Firebase.initializeApp();
  

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = (prefs.getBool('isLogged') ?? false);
  String tipo_usuario = prefs.getString("Tipo");
  var home_view;
  if((isLogged) && (tipo_usuario == 'Usuario')) {
    print("Value: $isLogged");
    print("LOGEADO COMO USUARIO");
    home_view = UserView();
  }
  else if((isLogged) && (tipo_usuario == 'Propietario')){
    print("LOGEADO COMO PROPIETARIO");
    home_view = Landlord();
  }

  else{
    print("LOGGEADO: $isLogged");
    home_view = MainScreen();
  }

  //else vista principal


  runApp(MaterialApp(
    title: 'i-hunt',
    home: home_view,//MainScreen(),

    routes: {
      '/login' : (context) => LoginPage(),
      '/user' : (context) => UserView(),
      '/landlord': (context) => Landlord(),
      '/register' : (context) => Register(),
      '/lugares': (context) => Lugares(),
      '/mapa' : (context) => MyMaps(),
      '/detalles': (context) => DetallesHab(),
      '/registerRoom' : (context) => RegisterRoom(),
      '/IHunt': (context) => MainScreen()

    },

  ));

}
