import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';

// Vistas de inquilino
import 'package:ihunt/vistas/inquilino/userView.dart'; // principal
import 'package:ihunt/vistas/inquilino/mis_lugares.dart';
import 'package:ihunt/vistas/inquilino/google_maps.dart';
import 'package:ihunt/vistas/inquilino/detalles_hab.dart';
import 'package:ihunt/vistas/notificaciones.dart';
import 'package:ihunt/vistas/inquilino/notificationes_inquilino.dart';
import 'package:ihunt/vistas/inquilino/detalles_invitacion.dart';


// VISTA PROPIETARIO
import 'vistas/propietario/landlordView.dart';
import 'package:ihunt/vistas/propietario/notificaciones_propietario.dart';
import 'vistas/propietario/registerRoom.dart';

// IMPORTAR VISTAS
import 'vistas/mainscreen.dart';
import 'vistas/register.dart';
import 'vistas/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init the firebase system
  await Firebase.initializeApp();


  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isLogged = (prefs.getBool('isLogged') ?? false);
  String tipoUsuario = prefs.getString("Tipo");
  var homeView;
  //print("Loggeado???? => $isLogged");

  if ((isLogged) && (tipoUsuario == 'Usuario')) {
    //print("LOGEADO COMO USUARIO");
    //homeView = LoginTest();
    homeView = UserView();
    //homeView = Notificaciones();
  } else if ((isLogged) && (tipoUsuario == 'Propietario')) {
    //print("LOGEADO COMO PROPIETARIO");
    homeView = Landlord();
  } else {
    homeView = MainScreen();
  }

  runApp(IHuntApp(homeView));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
      title: Text(widget.title),
    ));
  }
}

class IHuntApp extends StatelessWidget {
  IHuntApp(this.homeView);
  final homeView;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHunt',
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
        '/notificaciones': (context) => Notificaciones(),
        '/login': (context) => LoginPage(),
        '/user': (context) => UserView(),
        '/landlord': (context) => Landlord(),
        '/register': (context) => Register(),
        '/lugares': (context) => Lugares(),
        '/mapa': (context) => MyMaps(),
        '/detalles': (context) => DetallesHab(),
        '/registerRoom': (context) => RegisterRoom(),
        '/notificationesPropietario': (context) => NotificacionesPropietario(),
        '/notificacionesInquilino': (context) => NotificacionesInquilino(),
        '/detallesInvitacion': (context) => DetallesInvitacion(),
        '/IHunt': (context) => MainScreen()
      },
    );
  }
}
