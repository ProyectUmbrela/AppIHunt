import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
// Vistas de inquilino
import 'package:ihunt/vistas/inquilino/userView.dart'; // principal usuario
import 'package:ihunt/vistas/inquilino/misHabitaciones.dart';
import 'package:ihunt/vistas/inquilino/googleMaps.dart';
import 'package:ihunt/vistas/inquilino/detallesHabitacion.dart';
import 'package:ihunt/vistas/inquilino/invitaciones.dart';
import 'package:ihunt/vistas/inquilino/invitacionDetalles.dart';
import 'package:ihunt/vistas/propietario/rooms.dart';
import 'package:ihunt/providers/provider.dart';
//import 'package:ihunt/vistas/example.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


// VISTA PROPIETARIO
import 'vistas/propietario/landlordView.dart';
import 'vistas/propietario/registerRoom.dart';

// IMPORTAR VISTAS
import 'vistas/mainscreen.dart';
import 'vistas/register.dart';
import 'package:ihunt/vistas/loginPage.dart';

String version;
List<String> testDeviceIds = ['D69AD2F70B99972211345214A355C240'];




Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  RequestConfiguration configuration = RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);

  // init the firebase system
  await Firebase.initializeApp();


  runApp(IHuntApp());
}

Future<String> execute(
    InternetConnectionChecker internetConnectionChecker,
    ) async {
  // Simple check to see if we have Internet
  // ignore: avoid_print
  print('''The statement 'this machine is connected to the Internet' is: ''');
  final bool isConnected = await InternetConnectionChecker().hasConnection;
  // ignore: avoid_print
  print("============> ${isConnected.toString()}");
  // returns a bool

  // We can also get an enum instead of a bool
  // ignore: avoid_print
  print(
    'Current status: ${await InternetConnectionChecker().connectionStatus}',
  );
  // Prints either InternetConnectionStatus.connected
  // or InternetConnectionStatus.disconnected

  // actively listen for status updates
  final StreamSubscription<InternetConnectionStatus> listener =
  InternetConnectionChecker().onStatusChange.listen(
        (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
        // ignore: avoid_print
          print('Data connection is available.');
          return 'Yes';
          break;
        case InternetConnectionStatus.disconnected:
        // ignore: avoid_print
          print('You are disconnected from the internet.');
          return 'No';
          //break;
      }
    },
  );

  // close listener after 30 seconds, so the program doesn't run forever
  await Future<void>.delayed(const Duration(seconds: 30));
  await listener.cancel();

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
        .collection(GlobalDataUser().userCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

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
                  ]
              ),
            );
          }
          else if(snapshot.hasData) {
            try{
              print("#######################################################");
              print("#######################################################");
              print("A ${snapshot.data['tipo']}");
              print("B ${snapshot.data['usuario']}");
              print("#######################################################");
              print("#######################################################");
            }catch (error){
              if(error.toString().contains('Bad state')){
                return LoginPage();
              }else{
                return LoginPage();
              }
            }
            if (snapshot.data['tipo'] == 'Usuario'){
              return UserView();
            }
            else if (snapshot.data['tipo'] == 'Propietario'){
              return Landlord();
            }
            else{
              return LoginPage();
            }
          }
          else{
            return LoginPage();
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RentI',
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
            return MainScreen();
          }
        },
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      /*
      If the application is built using GlobalMaterialLocalizations.delegate, consider using GlobalMaterialLocalizations.delegates (plural) instead, as that will automatically declare the appropriate Cupertino localizations.
       The declared supported locales for this app are: en, es, zh, he, ru, fr_BE, fr_CA, ja, de, hi, ar

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
      ],*/
      locale: const Locale('es'),
      routes: {
        '/login': (context) => LoginPage(),
        '/user': (context) => UserView(),
        '/landlord': (context) => Landlord(),
        '/register': (context) => Register(),
        '/lugares': (context) => Lugares(),
        '/mapa': (context) => MyMaps(),
        '/detalles': (context) => DetallesHab(),
        //'/notificationesPropietario': (context) => NotificacionesPropietario(),
        '/notificacionesInquilino': (context) => InvitacionesInquilino(),
        '/detallesInvitacion': (context) => DetallesInvitacion(),
        '/IHunt': (context) => MainScreen(),
        '/registeroom': (context) => RegisterRoom(),
        '/rooms': (context) => Rooms()
      },
    );
  }
}
