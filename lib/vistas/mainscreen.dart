
import 'package:ihunt/vistas/register.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/vistas/loginPage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          title: new Text('Menu'),
        ),
        body: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 155.0),
                MaterialButton(
                  minWidth: 200.0,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  height: 40.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                      //MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  color: Colors.lightBlue,
                  child: Text('Registrarse',
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 15.0),
                MaterialButton(
                  minWidth: 200.0,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  height: 40.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  color: Colors.lightBlue,
                  child: Text('Iniciar sesion',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

