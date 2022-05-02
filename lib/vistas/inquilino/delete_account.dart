import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


class DeleteAccount extends StatelessWidget {
  User _currentUser;
  String _nombre;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //User? currentUser = await _auth.currentUser;


  void sendData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var metadata = user.metadata;


    /*_currentUser = FirebaseAuth.instance.currentUser;
    _currentUser.updateProfile(
      displayName: "Abel"
    ).then((value){
          print("Profile has been changed successfully");
          //DO Other compilation here if you want to like setting the state of the app
          _currentUser.reload();
        }).catchError((e){
          print("There was an error updating profile");
        });*/

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
                    print("######################## data have been sent");
                    Navigator.of(context).pop();
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
