import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:ihunt/utils/fire_auth.dart';
import 'package:ihunt/vistas/mainscreen.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:ihunt/providers/api.dart';
import 'package:ihunt/vistas/register.dart';
import 'package:ihunt/vistas/inquilino/userView.dart';

import 'package:ihunt/vistas/propietario/landlordView.dart';

//IMPORTAR FUNCIONES DE CARPETA utils
import 'package:ihunt/utils/widgets.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _saving = false;
  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();
  TextStyle style = TextStyle(fontSize: 18, color: Colors.black);

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
          Text('o'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget recuperarPass(){
    return InkWell(
      onTap: ()=> {},
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 30.0),
              alignment: Alignment.topRight,
              child: Text('¿Olvidaste tu contraseña?',
                  style: TextStyle(
                      fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Register()));

        },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "¿Aún no tienes una cuenta?",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Registrarme',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(seconds, message) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        Future.delayed(Duration(seconds: seconds), () {
        });
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

  /*
  onSuccess() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", true);
  }*/

  Future _sendRequest(emailField, passwordField) async {


   var user = await FireAuth
        .signInUsingEmailPassword(
      email: emailField.text,
      password: passwordField.text,
    );

    print("1 =================> ${user} <==============");
    if (user != null) {
      print("2 =================> ${user.uid} <==============");

      if (user.emailVerified){
        // API (email) => usuario, nombre, telefono

        var snapShoot = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapShoot != null){

          if (snapShoot['tipo'] == 'Propietario'){
            print("USUARIO: ######## ${snapShoot['tipo']}");

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Landlord(),
              ),
            );
          }
          else if (snapShoot['tipo'] == 'Usuario'){
            print("USUARIO: ######## ${snapShoot['tipo']}");

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => UserView()));
          }
          else{

            setState(() => _saving = false);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
            );
          }
        }
      }else{
        _showDialog(2, "Tu cuenta aún no ha sido verificada. Revisa tu correo para confirmar");
        setState(() => _saving = false);
      }
    }else{
      _showDialog(2, "Usuario o contraseña incorrectos");
      setState(() => _saving = false);
    }
  }


  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
        autofocus: true,
        controller: myControllerEmail,
        decoration: buildInputDecoration("Correo", Icons.email));

    final passwordField = TextFormField(
        autofocus: false,
        controller: myControllerPassword,
        obscureText: true,
        decoration: buildInputDecoration("Contraseña", Icons.remove_red_eye));

    final loginbuton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() => _saving = true);
          _sendRequest(myControllerEmail, myControllerPassword);
          //
        },
        child: Text("Ingresar",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white)),
      )
    );


    return Scaffold(
      body: ModalProgressHUD(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(60.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 30.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Correo o usuario"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 30.0),
                    child: emailField,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 30.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Contraseña"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 30.0),
                    child: passwordField,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 30.0),
                    child: loginbuton,
                  ),
                  recuperarPass(),
                  _divider(),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                  ),
                  _createAccountLabel()
                ],
              ),
            ),
          ),
          inAsyncCall: _saving
      ),
    );
  }
}
