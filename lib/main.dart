import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Vistas de inquilino
import 'package:ihunt/vistas/inquilino/userView.dart'; // principal usuario
import 'package:ihunt/vistas/inquilino/misLugares.dart';
import 'package:ihunt/vistas/inquilino/googleMaps.dart';
import 'package:ihunt/vistas/inquilino/detallesHabitaciones.dart';
import 'package:ihunt/vistas/inquilino/notificationesInquilino.dart';
import 'package:ihunt/vistas/inquilino/notificaciones.dart';


// VISTA PROPIETARIO
import 'vistas/propietario/landlordView.dart';
import 'package:ihunt/vistas/propietario/notificaciones_propietario.dart';
import 'vistas/propietario/registerRoom.dart';

// IMPORTAR VISTAS
import 'vistas/mainscreen.dart';
import 'vistas/register.dart';



import 'package:ihunt/vistas/loginPage.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // init the firebase system
  await Firebase.initializeApp();


  runApp(IHuntApp());
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
        )
    );
  }
}

class IHuntApp extends StatelessWidget {

  Future getUsuario()async{

    var dataUser = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    //print("==============> ${FirebaseAuth.instance.currentUser.uid}");
    return dataUser;
  }

  Widget getViewWidget() {

    return FutureBuilder(
        future: getUsuario(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            // Esperando la respuesta de la API
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    //Text('Cargando...'),
                  ]
              ),
            );
          }
          else if(snapshot.hasData) {

            print("ELSE CONDITIION");
            print("#######################################################");
            print("#######################################################");

            print("${snapshot.data['tipo']}");
            print("${snapshot.data['usuario']}");
            print("#######################################################");
            print("#######################################################");

            if (snapshot.data['tipo'] == 'Usuario'){
              return UserView();
            }else{
              return Landlord();
            }
          }
          else{
            return MainScreen();
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renti',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot){
          if (userSnapshot.connectionState != ConnectionState.active) {
            return Center(
                child: CircularProgressIndicator()
            );
          }

          if (userSnapshot.data != null && FirebaseAuth.instance.currentUser.emailVerified){
            return getViewWidget();
          }
          else {
            print("user is not logged in");
            return MainScreen();
          }
        },
      ),
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
        '/login': (context) => LoginPage(),
        //'/Init': (context) => Inicio(),
        '/user': (context) => UserView(),
        '/landlord': (context) => Landlord(),
        '/register': (context) => Register(),
        '/lugares': (context) => Lugares(),
        '/mapa': (context) => MyMaps(),
        '/detalles': (context) => DetallesHab(),
        '/notificationesPropietario': (context) => NotificacionesPropietario(),
        '/notificacionesInquilino': (context) => NotificacionesInquilino(),
        '/detallesInvitacion': (context) => DetallesInvitacion(),
        '/IHunt': (context) => MainScreen(),
        '/registeroom': (context) => RegisterRoom()
      },
    );
  }
}
