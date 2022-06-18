import 'package:ihunt/providers/provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:ihunt/providers/api.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ihunt/vistas/register.dart';
import 'package:ihunt/vistas/inquilino/userView.dart';
import 'package:ihunt/vistas/propietario/landlordView.dart';
import 'package:ihunt/utils/fire_auth.dart';
import 'package:ihunt/vistas/mainscreen.dart';
import 'package:ihunt/utils/widgets.dart';
import 'dart:async';
import 'package:ihunt/utils/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ihunt/vistas/recuperarContrasena.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey = new GlobalKey<FormState>();
  bool _saving = false;
  int statusCode;
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecuperarContrasena()));
        },
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
              'Quiero registrarme',
              style: TextStyle(
                  color: Colors.black,//Colors.amber.shade900, //0xfff79c4f - 0xFF000000
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

  Future sendData(var correo) async {

    Api _api = Api();
    final body = jsonEncode({
      'correo': correo
    });

    var response = await _api.EnabledCuenta(body);
    statusCode = response.statusCode;
    var resp = json.decode(response.body);
    print("#################### 1 response: ${statusCode}");
    print("#################### 2 response: ${resp}");
    return statusCode;

  }

  showAlertDialog(BuildContext context, var message, var correo) {
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed:  (){
        sendData(correo).then((response) {
          print("############# value returned: ${response}");
          if(response == 416){
            Navigator.of(context).pop();
            _showDialog(2, "Tu cuenta ya se encuentra en proceso de eliminación");
          }else{
            Navigator.of(context).pop();
            _showDialog(2, "Solicitud cancelada, vuelve a recargar la aplicación");
          }
        }).catchError((e) {
          Navigator.of(context).pop();
          _showDialog(2, "Ocurrió un error con tu solicitud");
        });

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cuenta desactivada"),
      content: Text("¿Deseas volver a activar tu cuenta?"),
      actions: [
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _sendRequest(emailField, passwordField) async {

  final form = formKey.currentState;
  if(form.validate()){
    var user = await FireAuth
        .signInUsingEmailPassword(
      email: emailField.text,
      password: passwordField.text,
    );

    print("1 =================> ${user[0]} <==============");
    print("2 =================> ${user[1]} <==============");
    if (user[0] != null) {

      if (user[0].emailVerified){

        var snapShoot = await FirebaseFirestore
            .instance
            .collection(GlobalDataUser().userCollection)
            .doc(user[0].uid)
            .get();

        if (snapShoot != null){
          if (snapShoot['tipo'] == 'Propietario'){

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Landlord(),
              ),
            );
          }
          else if (snapShoot['tipo'] == 'Usuario'){

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

      if (user[1] == 'user-disabled'){
        var message = "La cuenta ha sido desactivada";
        showAlertDialog(context, message, emailField.text);
        setState(() => _saving = false);

      }else{
        _showDialog(2, "Usuario o contraseña incorrectos");
        setState(() => _saving = false);
      }
    }
  }else{
    setState(() => _saving = false);
  }

  }

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
        autofocus: false,
        controller: myControllerEmail,
        validator: validateEmail,
        decoration: buildInputDecoration("Correo", Icons.email));

    final passwordField = TextFormField(
        autofocus: false,
        controller: myControllerPassword,
        obscureText: true,
        validator: validateSinglePassword,
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
        },
        child: Text("Ingresar",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white)),
      )
    );

    final heighT = MediaQuery.of(context).size.height * 0.08;

    return Scaffold(
      body: ModalProgressHUD(
          child: Container(
            child: Form(
              key: formKey,
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
                          child: Text("Correo"),
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
                      padding: new EdgeInsets.all(heighT),
                    ),
                    _createAccountLabel()
                  ],
                ),
              ),
            ),
          ),
          inAsyncCall: _saving,
      ),
    );
  }
}
