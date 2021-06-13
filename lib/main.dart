import 'package:flutter/material.dart';

// IMPORTAR VISTAS
import 'vistas/mainscreen.dart';
import 'vistas/register.dart';
import 'vistas/login.dart';

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
      //home: MainScreen(),
      debugShowCheckedModeBanner: false, // quitar etiqueta debug en los screen
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/homeS': (BuildContext context) => new MainScreen(),
        '/register': (BuildContext context) => new Register()
      },
    );
  }
}
