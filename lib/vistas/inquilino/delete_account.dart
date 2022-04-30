import 'package:flutter/material.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({Key key}) : super(key: key);



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
