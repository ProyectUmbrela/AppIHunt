//import 'dart:js';
import 'package:flutter/material.dart';
import 'vistas/propietario/registerRoom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';

// Vistas de inquilino
import 'package:ihunt/vistas/inquilino/userView.dart'; // principal
import 'package:ihunt/vistas/inquilino/mis_lugares.dart';
import 'package:ihunt/vistas/inquilino/google_maps.dart';
import 'package:ihunt/vistas/inquilino/detalles_hab.dart';
import 'package:ihunt/vistas/inquilino/notificaciones.dart';


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
  String tipoUsuario = prefs.getString("Tipo");
  var homeView;
  if((isLogged) && (tipoUsuario == 'Usuario')) {
    print("Value: $isLogged");
    print("LOGEADO COMO USUARIO");
    //homeView = UserView();
    homeView = Notificaciones();
  }
  else if((isLogged) && (tipoUsuario == 'Propietario')){
    print("LOGEADO COMO PROPIETARIO");
    homeView = Landlord();
  }

  else{
    print("LOGGEADO: $isLogged");
    homeView = MainScreen();
  }


  runApp(MaterialApp(
    title: 'i-hunt',
    home: homeView,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en'),
      const Locale('es'),
      const Locale('zh'),
      const Locale('he'),
      const Locale('ru'),
      const Locale('fr', 'BE'),
      const Locale('fr', 'CA'),
      const Locale('ja'),
      const Locale('de'),
      const Locale('hi'),
      const Locale('ar'),
    ],
    locale: const Locale('es'),
    routes: {
      '/Notificaciones': (context) => Notificaciones(),
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
