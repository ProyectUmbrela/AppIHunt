import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:ihunt/providers/api.dart';



class DeleteAccount extends StatelessWidget {


  Future sendData(var correo) async {

    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    String tokenAuth = await FirebaseAuth.instance.currentUser.getIdToken();
    print("=============================== ${tokenAuth}");
    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");

    Api _api = Api();
    final body = jsonEncode({
      'correo': correo
    });
    print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
    var response = await _api.DisabledCuenta(body, tokenAuth);

    int statusCode = response.statusCode;
    var resp = json.decode(response.body);
    print("#################### 1 response: ${statusCode}"); // 201
    print("#################### 2 response: ${resp}");       // {code: success, message: Se ha desactivado el usuario desonses@gmail.com }

  }

  void _showDialog(BuildContext context, seconds, message) {
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

  DeleteAccount({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    var message = 'Podrás cancelar la eliminación de cuenta antes de 24 horas una vez realizada tu solicitud, después de este tiempo no podrás revertir el proceso. Tu cuenta será eliminada en un periodo de 24 a 72 horas.';

    TextEditingController _textFieldController = TextEditingController();

    _displayDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Ingresa el correo electrónico asociado a tu cuenta. Una vez confirmado tu sesión será cerrada.'),
              content: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "correo electrónico"),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: Text('Enviar'),
                  onPressed: () {
                    var isEmail = validateEmail(_textFieldController.text);
                    if (isEmail == 'email-valid'){

                      print("**************** To send data");
                      print("************** result if is a valid email: ${isEmail}");

                      sendData(_textFieldController.text);
                      Navigator.of(context).pop();
                      _showDialog(context, 2, "Solicitud exitosa");
                    }
                    else{
                      print("****************** Email not valid");
                    }
                  },
                )
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),

      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                child: Text(
                message,
                style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54)
            )),
            //RaisedButton(onPressed: () {}, child: Text('Button'),), // your button beneath text
            Material(
                borderRadius: BorderRadius.circular(5),
                child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.90,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {
                      _displayDialog(context);
                    },
                    color: Color(0xFFE0E0E0), // 0xFFE0E0E0 , 0xFFEEEEEE
                    child: Text("Eliminar cuenta",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0, color: Colors.black)
                    )
                )
            )
          ],
        ),
      )
    );
  }
}
