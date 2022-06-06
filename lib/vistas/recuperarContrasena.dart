import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihunt/providers/api.dart';
//import 'package:ihunt/utils/fire_auth.dart';
import 'package:ihunt/utils/widgets.dart';
import 'package:ihunt/vistas/loginPage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({Key key}) : super(key: key);

  @override
  _RecuperarContrasenaState createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {

  bool _saving = false;
  final myControllerEmail = TextEditingController();
  TextStyle style = TextStyle(fontSize: 18, color: Colors.black);

  Widget recuperarPass(){
    return InkWell(
      onTap: () {
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
          ),
        ],
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


  Future _sendRequest(emailField) async {
    print("******************* EMAIL: ${emailField}");
    Api _api = Api();
    final body = jsonEncode({
      'usuario': emailField
    });

    var response = await _api.resetPasswordPost(body);

    //int statusCode = response.statusCode;
    var resp = json.decode(response.body);

    print("======================> ${resp}");

    // {code: badRequest, message: Usuario no existe}
    // {message: Se ha enviado el correo para restablecer contraseña a desonses@gmail.com}


    if (resp['code'] == 'badRequest'){
      print("A ${resp['message']}");
      _showDialog(1, 'El correo no existe');
      setState(() => _saving = false);
    }
    else{
      print("B ${resp['message']}");
      _showDialog(2, 'Se ha enviado un correo para recuperar tu contraseña');
      setState(() => _saving = false);

      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
        autofocus: true,
        controller: myControllerEmail,
        decoration: buildInputDecoration("Correo", Icons.email));


    final loginbuton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            setState(() => _saving = true);
            _sendRequest(myControllerEmail.text);
            //
          },
          child: Text("Recuperar contraseña",
              textAlign: TextAlign.center,
              style: style.copyWith(color: Colors.white)),
        ),
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
                        vertical: 20.0,
                        horizontal: 30.0),
                    child: loginbuton,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                  ),
                ],
              ),
            ),
          ),
          inAsyncCall: _saving,
      ),
    );
  }

}


