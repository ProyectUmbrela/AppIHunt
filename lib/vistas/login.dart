import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _saving = false;

  /*
  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],*/
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: Text(
        'Ingresar',
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
  */

  /*
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }*/

  void _showDialog(seconds, message) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        Future.delayed(Duration(seconds: seconds), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: Text(message),
        );
      },
    );
  }

  void _submit() {
    setState(() {
      _saving = true;
    });

    //Simulate a service call
    //print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 4), () {
      setState(() {
        _saving = false;
      });
    });
  }

  Future _sendRequest(emailField, passwordField) async {
    //Api _api = Api();
    _submit();
    print("====================");
    print(emailField.text);
    print(passwordField.text);
    print("====================");
    final body = jsonEncode(
        {'idusuario': emailField.text, 'contrasena': passwordField.text});
    final headers = {"Content-Type": "application/json"};
    String url = 'https://appiuserstest.herokuapp.com/ihunt/test';
    var response = await http.post(url, headers: headers, body: body);

    int statusCode = response.statusCode;
    if (statusCode == 201) {
      //print("***********login");
      _showDialog(1, "Loggeado");
    } else {
      _showDialog(2, "El usuario o contraseña son incorrectos");
    }
    String responseBody = response.body;
    print(responseBody);
  }

  TextStyle style = TextStyle(fontSize: 18, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    final myControllerEmail = TextEditingController();
    final myControllerPassword = TextEditingController();

    final emailField = TextFormField(
        autofocus: false,
        controller: myControllerEmail,
        //validator: validateEmail,
        decoration: buildInputDecoration("Correo", Icons.email));

    final passwordField = TextFormField(
        autofocus: false,
        controller: myControllerPassword,
        obscureText: true,
        //validator: (value) => value.isEmpty ? "Your name is required" : null,
        decoration: buildInputDecoration("Contraseña", Icons.remove_red_eye));

    final loginbuton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => _sendRequest(myControllerEmail, myControllerPassword),
        child: Text("Ingresar",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white)),
      ),
    );

    return Scaffold(
      body: ModalProgressHUD(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  label("Correo o usuario"),
                  SizedBox(height: 15.0),
                  emailField,
                  SizedBox(height: 15.0),
                  //space
                  label("Contraseña"),
                  SizedBox(height: 15.0),
                  passwordField,
                  SizedBox(
                    height: 45.0,
                  ),
                  //space
                  loginbuton,
                  SizedBox(
                    height: 35.0,
                  ),
                ],
              ),
            ),
          ),
          inAsyncCall: _saving),
    );
  }
}
