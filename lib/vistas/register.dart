
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:flutter/widgets.dart';
import 'package:ihunt/utils/widgets.dart';

import 'dart:io' show Platform, sleep;

// Paquetes para consumir api
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();
  //bool _loading = false;
  bool _saving = false;
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
      validator: (value) => value.isEmpty ? "Usuario requerido" : null,
      onSaved: (value) => _userid = value,
      decoration: buildInputDecoration("Username", Icons.account_box),
    );

    final userName = TextFormField(
      autofocus: false,
      controller: usernameCtrl,
      validator: (value) => value.isEmpty ? "Nombre requerido" : null,
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
      validator: (value) => value.isEmpty ? "Contraseña requerida" : null,
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
        //title: _dialogTitle(noty),
        content: _contentText(texto),
        //actions: _buildActions(),
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

    void clearForm() {
      //fieldText.clear();
      useridCtrl.clear();
      usernameCtrl.clear();
      useremailCtrl.clear();
      userphoneCtrl.clear();
      passwordCtrl.clear();
      confirmPasswordCtrl.clear();
    }

    Future submit() async {

      final form = formKey.currentState;

      if (form.validate()) {
        /*setState(() {
          _saving = true;
        });*/



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

        print("############## ${data}");
        if (response.statusCode == 201) {

          // CHECAR BIEN LOS CODIDOS DE RESPUESTA
          debugPrint("Data posted successfully");
          setState(() => _saving = false);

          _materialAlertDialog(context, 'Registro exitoso, revisa tu correo para completar tu registro', 'Notificación');
          clearForm();
          //Navigator.pushReplacementNamed(context, '/login');


        }
        else if(data['message'] == 'El usuario ya existe'){
          //print("El usuario ya existe");
          setState(() {
            _saving = false;
          });

          _materialAlertDialog(context, 'Ya existe una cuenta con este correo', 'Notificación');
          //useridCtrl.clear();
        } else {
          if (Platform.isAndroid) {
            setState(() {
              _saving = false;
            });
            _materialAlertDialog(context, data['message'], 'Notificación');
            //print(response.statusCode);
            //print("Android platform ******************************************");

          } else if (Platform.isIOS) {
            setState(() {
              _saving = false;
            });
            _cupertinoDialog(context, data['message'], 'Notificación');
            //print("IOS platform ******************************************");

          }
        }
      } else {
        setState(() {
          _saving = false;
        });
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


    TextStyle style = TextStyle(fontSize: 15, color: Colors.white);
    final registerbuton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          //height: 20,
          minWidth: 100,
          onPressed: () {
            setState(() => _saving = true);
            submit();
          },
          child:SizedBox(
              child: Text("Registrar",
                  textAlign: TextAlign.center,
                  style: style.copyWith())),
        )
    );

    final cancelbuton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          //height: 20,
          minWidth: 100,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child:SizedBox(
              child: Text("Cancelar",
                  textAlign: TextAlign.center,
                  style: style.copyWith())),
        )
    );


    return Scaffold(
        body: ModalProgressHUD(
            child: Container(
              padding: EdgeInsets.all(40.0),
              child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //logo,
                        SizedBox(height: 15),
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
                            registerbuton,
                            Spacer(),
                            cancelbuton
                            /*
                            Expanded(
                                /*child: Container(
                                  child: _loading ? CircularProgressIndicator() :
                                  longButtons("Registrar", submit),
                                  alignment: Alignment.centerLeft,
                                )*/
                                child: registerbuton
                            ),
                            Expanded(
                                /*child: Container(
                                  child: longButtons("Cancelar", canceled),
                                  alignment: Alignment.centerRight,
                                )*/
                              child: cancelbuton,

                            ),*/
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  )),
            ),
            inAsyncCall: _saving
        )
    );



    /*
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
                              longButtons("Registrar", submit),
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

  */
  }
}
