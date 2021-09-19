import 'package:flutter/material.dart';
import 'package:ihunt/vistas/landlordView.dart';
import 'package:ihunt/vistas/registerRoom.dart';
import 'package:ihunt/vistas/userView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

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
    home = User();
  else
    home = LoginPage() ;

  //runApp(MyApp());

  runApp(MaterialApp(
    title: 'i-hunt',
    home: home,
    routes: {
      '/login' : (context) => LoginPage(),
      '/user' : (context) => User(),
      '/register' : (context) => Register()
    },

  ));

}









/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.s
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'i-Hunt',
      theme: ThemeData(
        fontFamily: 'Brand-Bold',
        primarySwatch: Colors.blue,
      ),

      home: LoginPage(),
=======
      home: Landlord(),
      //home: LoginPage(),

      debugShowCheckedModeBanner: false, // quitar etiqueta debug en los screen
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/homeS': (BuildContext context) => new MainScreen(),
        '/register': (BuildContext context) => new Register(),
        '/landlord': (BuildContext context) => new Landlord(),
        '/user': (BuildContext context) => new User()
      },
    );
  }
}
*/