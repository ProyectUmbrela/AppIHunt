import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';

// Vistas de inquilino
import 'package:ihunt/vistas/inquilino/userView.dart'; // principal usuario
import 'package:ihunt/vistas/inquilino/mis_lugares.dart';
import 'package:ihunt/vistas/inquilino/google_maps.dart';
import 'package:ihunt/vistas/inquilino/detalles_hab.dart';
//import 'package:ihunt/vistas/notificaciones.dart';
import 'package:ihunt/vistas/inquilino/notificationes_inquilino.dart';
import 'package:ihunt/vistas/inquilino/detalles_invitacion.dart';
//import 'package:ihunt/vistas/inquilino/inicio.dart';

//import 'package:flutter/material.dart';


// VISTA PROPIETARIO
import 'vistas/propietario/landlordView.dart';
import 'package:ihunt/vistas/propietario/notificaciones_propietario.dart';
import 'vistas/propietario/registerRoom.dart';

// IMPORTAR VISTAS
import 'vistas/mainscreen.dart';
import 'vistas/register.dart';
//import 'vistas/login.dart';



import 'package:ihunt/vistas/loginTest.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // init the firebase system
  await Firebase.initializeApp();

  //SharedPreferences prefs = await SharedPreferences.getInstance();

  //bool isLogged = (prefs.getBool('isLogged') ?? false);
  //var tipoUser = (prefs.getString('tipoUsuario') ?? 'error');
  //var idUsuario;
  //var user;
  var homeView;
  //print("Loggeado???? => $isLogged");
  //print("Loggeado???? => $tipoUsuario");

  /*
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });*/
  
  /*
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User _user) async{
        if (_user == null) {
          print('User is currently signed out!');

        } else {
          print('User is currently log in: ${_usuario}');
          var snapShoot = await FirebaseFirestore
              .instance
              .collection('users')
              .doc(_user.uid)
              .get();
          if (snapShoot != null){
            tipoUser = snapShoot['tipo'];
            //var _idUsuario = snapShoot['usuario'];

            if (tipoUser == 'propietario'){
              print("1 USUARIO: ######## ${snapShoot['tipo']}");
            }
            else if(tipoUser == 'usuario'){
              print("2 USUARIO: ######## ${snapShoot['tipo']}");
            }
            else{
              print("Tipo de usuario no conocido");
            }
          }
          else{
            print("Usuario no encontrado...");
          }
        }
      });
    */
  /*
      print('User is signed in!');
      var snapShoot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_user.uid)
          .get();
      print("########################");
      if (snapShoot != null){
        var tipoUsuario = snapShoot['tipo'];

        if (tipoUsuario == 'propietario'){
          print("USUARIO: ######## ${snapShoot['tipo']}");
          //Navigator.pushReplacementNamed(context, '/landlord');

        }
        else if (tipoUsuario == 'usuario'){
          print("USUARIO: ######## ${snapShoot['tipo']}");
          print("${_user}");

          //Navigator.pushReplacementNamed(context, '/user');
          /*Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserView(
                  user: user,
                  idUsuario: idUsuario
              ),
            ),
          );*/
        }
      }else{
        print("No encontrado...");

      }
    }
  });*/

  /*
  print("##################### 0");
  if ((isLogged) && (tipoUser == 'Usuario')) {

    print("##################### 1");
    //homeView = UserView();
    print("============> ${_usuario}");
    homeView = UserView(user:_usuario, idUsuario: 'fredy2018');
    print("LOGEADO COMO USUARIO");

  } else if ((isLogged) && (tipoUser == 'Propietario')) {
    print("##################### 2");
    //print("LOGEADO COMO PROPIETARIO");
    homeView = Landlord();
  } else {
    print("##################### 3");
    homeView = MainScreen();
  }*/

  runApp(IHuntApp(homeView));
}


class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //var user;


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



  IHuntApp(this.homeView);
  var homeView;
    // This widget is the root of your application.
  /*
  Future<void> getDetalles() async{
    final result = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get().then((value) {
          if(value['tipo'] == 'usuario'){
            print(value);
          }
        }
    );

  }*/


  Future getDetalles()async{

    var dataUser = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    return dataUser;
  }

  Widget projectWidget() {

    return FutureBuilder(
        future: getDetalles(),
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
            print("#######################################################");
            print("#######################################################");
            return UserView(
              user: FirebaseAuth.instance.currentUser,
              idUsuario: 'fredy2018',);
            //return Center();
          }
          else{

            return UserView(
              user: FirebaseAuth.instance.currentUser,
              idUsuario: 'fredy2018',);
          }
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHunt',
      //home: homeView,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot){
          if (userSnapshot.connectionState != ConnectionState.active) {
            return Center(
                child: CircularProgressIndicator()
            );
          }
          final user = userSnapshot.data;
          if (user != null && FirebaseAuth.instance.currentUser.emailVerified == true){
            /*var dataUser = FirebaseFirestore
                .instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .get();*/
            return projectWidget();
            /*return UserView(
              user: FirebaseAuth.instance.currentUser,
              idUsuario: 'fredy2018',);*/
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
        //'/notificaciones': (context) => Notificaciones(),
        '/login': (context) => LoginPageTest(),//LoginPage(),
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
