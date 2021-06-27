import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:flutter/widgets.dart';
import 'package:ihunt/utils/widgets.dart';

import 'dart:io' show Platform;

// Paquetes para consumir api
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();
  bool _loading = false;

  TextEditingController useridCtrl = new TextEditingController();
  TextEditingController usernameCtrl = new TextEditingController();
  TextEditingController useremailCtrl = new TextEditingController();
  TextEditingController userphoneCtrl = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();
  TextEditingController confirmPasswordCtrl = new TextEditingController();
  TextEditingController chosenValueCtrl = new TextEditingController();

  String _userid,
      _username,
      _useremail,
      _userphone,
      _password,
      _confirmPassword;
  String _chosenValue;

  @override
  Widget build(BuildContext context) {

    final type = DropdownButtonFormField<String>(
      value: _chosenValue,
      hint: Text(
        'Elige tu role',
      ),
      onChanged: (value) =>
          setState(() => _chosenValue = value),
      validator: (value) => value == null ? 'Por favor elige un role' : null,
      items:
      ['Propietario', 'Usuario'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );


    final userId = TextFormField(
      autofocus: false,
      controller: useridCtrl,
      validator: (value) => value.isEmpty ? "Your userId is required" : null,
      onSaved: (value) => _userid = value,
      decoration: buildInputDecoration("Username", Icons.account_box),
    );

    final userName = TextFormField(
      autofocus: false,
      controller: usernameCtrl,
      validator: (value) => value.isEmpty ? "Your name is required" : null,
      onSaved: (value) => _username = value,
      decoration:
          buildInputDecoration("First and last name", Icons.accessibility),
    );

    final userEmail = TextFormField(
      autofocus: false,
      controller: useremailCtrl,
      validator: validateEmail,
      onSaved: (value) => _useremail = value,
      decoration: buildInputDecoration("Email", Icons.email),
    );

    final userPhone = TextFormField(
      autofocus: false,
      controller: userphoneCtrl,
      validator: validateMobile,
      onSaved: (value) => _userphone = value,
      decoration: buildInputDecoration("Phone number", Icons.phone_android),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordCtrl,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration:
          buildInputDecoration("Confirm password", Icons.remove_red_eye),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      controller: confirmPasswordCtrl,
      validator: (value) => validatePassword(value, passwordCtrl.text),
      onSaved: (value) => _confirmPassword = value,
      obscureText: true,
      decoration:
          buildInputDecoration("Confirm password", Icons.remove_red_eye),
    );

    /**** VENTANAS DE DIALOGO PARA EL ERROR DE LA API O FORMULARIO****/
    Widget _buildActionButton(String title, Color color) {
      return FlatButton(
        child: Text(title),
        textColor: color,
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }

    Widget _dialogTitle(String noty) {
      return Text(noty);
    }

    List<Widget> _buildActions() {
      return [_buildActionButton("Aceptar", Colors.blue)];
    }

    Widget _contentText(String texto) {
      return Text(texto);
    }

    Widget _showCupertinoDialog(String texto, noty) {
      return CupertinoAlertDialog(
        title: _dialogTitle(noty),
        content: _contentText(texto),
        actions: _buildActions(),
      );
    }

    Future<void> _cupertinoDialog(
        BuildContext context, String texto, String noty) async {
      return showCupertinoDialog<void>(
        context: context,
        builder: (_) => _showCupertinoDialog(texto, noty),
      );
    }

    Widget _showMaterialDialog(String texto, String noty) {
      return AlertDialog(
        title: _dialogTitle(noty),
        content: _contentText(texto),
        actions: _buildActions(),
      );
    }

    Future<void> _materialAlertDialog(
        BuildContext context, String texto, String noty) async {
      return showDialog<void>(
        context: context,
        builder: (_) => _showMaterialDialog(texto, noty),
      );
    }
    /***************************************************************************/

    var canceled = () async {
      Navigator.pushReplacementNamed(context, '/register');
    };

    Future submit() async {
      final form = formKey.currentState;

      if (form.validate()) {
        setState(() {
          _loading = true;
        });

        form.save();
        Api _api = Api();

        final msg = jsonEncode({
          'idusuario': useridCtrl.text,
          'nombre': usernameCtrl.text,
          'correo': useremailCtrl.text,
          'telefono': userphoneCtrl.text,
          'contrasena': passwordCtrl.text,
          'tipo': _chosenValue
        });

        print(msg);

        var response = await _api.registerPost(msg);
        Map data = jsonDecode(response.body);

        if (response.statusCode == 201) {
          // CHECAR BIEN LOS CODIDOS DE RESPUESTA
          debugPrint("Data posted successfully");

          setState(() {
            _loading = false;
          });

          Navigator.pushReplacementNamed(context, '/login');
        } else {
          setState(() {
            _loading = false;
          });
          if (Platform.isAndroid) {
            _materialAlertDialog(context, data['message'], 'Notificación');
            print(response.statusCode);
          } else if (Platform.isIOS) {
            _cupertinoDialog(context, data['message'], 'Notificación');
          }
        }
      } else {
        if (Platform.isAndroid) {
          _materialAlertDialog(
              context,
              "Por favor, rellene el formulario correctamente",
              "Formulario inválido");
        } else if (Platform.isIOS) {
          _cupertinoDialog(
              context,
              "Por favor, rellene el formulario correctamente",
              "Formulario inválido");
        }
      }
    };

    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //logo,

                  label("Nombre de usuario"),
                  SizedBox(height: 5),
                  userId,
                  SizedBox(
                    height: 15,
                  ),

                  label("Nombre completo"),
                  SizedBox(height: 5),
                  userName,
                  SizedBox(
                    height: 15,
                  ),

                  label("Correo electrónico"),
                  SizedBox(height: 5.0),
                  userEmail,
                  SizedBox(height: 15.0),

                  label("Teléfono"),
                  SizedBox(height: 5.0),
                  userPhone,
                  SizedBox(height: 15.0),

                  label("Contraseña"),
                  SizedBox(height: 10.0),
                  passwordField,
                  SizedBox(height: 15.0),

                  label("Confirmar contraseña"),
                  SizedBox(height: 10.0),
                  confirmPassword,

                  SizedBox(height: 15),
                  type,

                  SizedBox(height: 15.0),
                  //longButtons("Registrar", submit),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: _loading ? CircularProgressIndicator() :
                          longButtons("Aceptar", submit),
                        alignment: Alignment.centerLeft,
                      )),
                      Expanded(
                          child: Container(
                        child: longButtons("Cancelar", canceled),
                        alignment: Alignment.centerRight,
                      )),
                    ],
                  )
                ],
              ),
            )),
      ),
    ));
  }
}
