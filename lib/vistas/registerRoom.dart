import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:ihunt/utils/widgets.dart';

class RegisterRoom extends StatefulWidget {
  @override
  _RegisterRoomState createState() => _RegisterRoomState();
}


class _RegisterRoomState extends State<RegisterRoom> {

  final formKey = new GlobalKey<FormState>();

  TextEditingController roomidCtrl = new TextEditingController();
  TextEditingController adressCtrl = new TextEditingController();
  TextEditingController dimensionsCtrl = new TextEditingController();
  TextEditingController servicesCtrl = new TextEditingController();
  TextEditingController descriptionCtrl = new TextEditingController();
  TextEditingController priceCtrl = new TextEditingController();
  TextEditingController termsCtrl = new TextEditingController();

  String _roomid, _adress, _dimensions, _services, _description, _price, _terms;

  @override
  Widget build(BuildContext context) {

    final roomId = TextFormField(
      autofocus: false,
      controller: roomidCtrl,
      validator: (value) => value.isEmpty ? "Your roomId is required" : null,
      onSaved: (value) => _roomid = value,
      decoration: buildInputDecoration("room name", Icons.airline_seat_individual_suite),
    );

    final adress = TextFormField(
      autofocus: false,
      controller: adressCtrl,
      validator: (value) => value.isEmpty ? "La dirección de la habitación es requerida" : null,
      onSaved: (value) => _adress = value,
      decoration:
      buildInputDecoration("Dirección", Icons.map),
    );

    final dimensions = TextFormField(
      autofocus: false,
      controller: dimensionsCtrl,
      validator: (value) => value.isEmpty ? "La dimensión de la habitacón es requerida" : null,
      onSaved: (value) => _dimensions = value,
      decoration: buildInputDecoration("Dimensión", Icons.menu),
    );

    final services = TextFormField(
      autofocus: false,
      controller: servicesCtrl,
      obscureText: true,
      onSaved: (value) => _services = value,
      decoration:
      buildInputDecoration("Servicios", Icons.local_laundry_service),
    );

    final description = TextFormField(
      autofocus: false,
      controller: descriptionCtrl,
      onSaved: (value) => _description = value,
      obscureText: true,
      decoration:
      buildInputDecoration("Descripción", Icons.description),
    );

    final price = TextFormField(
      autofocus: false,
      controller: priceCtrl,
      onSaved: (value) => _price = value,
      obscureText: true,
      decoration:
      buildInputDecoration("Precio", Icons.monetization_on),
    );
    final terms = TextFormField(
      autofocus: false,
      controller: termsCtrl,
      onSaved: (value) => _terms = value,
      obscureText: true,
      decoration:
      buildInputDecoration("Términos", Icons.add_alert),
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
        form.save();
        Api _api = Api();

        var date = new DateTime.now();
        final msg = jsonEncode({
          'idhabitación': roomidCtrl.text,
          'direccion': adressCtrl.text,
          'dimension': dimensionsCtrl.text,
          'servicios': servicesCtrl.text,
          'descripcion': descriptionCtrl.text,
          'precio' : priceCtrl.text,
          'terminos' : termsCtrl.text,
          'fecharegistro': date
        });

        print(msg);

        var response = await _api.registerPost(msg);
        Map data = jsonDecode(response.body);

        if (response.statusCode == 201) {
          // CHECAR BIEN LOS CODIDOS DE RESPUESTA
          debugPrint("Data posted successfully");
          Navigator.pushReplacementNamed(context, '/homeS');
        } else {
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
    }

    ;

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

                      label("Id habitación"),
                      SizedBox(height: 5),
                      roomId,
                      SizedBox(
                        height: 15,
                      ),

                      label("Dirección"),
                      SizedBox(height: 5),
                      adress,
                      SizedBox(
                        height: 15,
                      ),

                      label("Dimensión de la habitación"),
                      SizedBox(height: 5.0),
                      dimensions,
                      SizedBox(height: 15.0),

                      label("Servicios incluidos"),
                      SizedBox(height: 5.0),
                      services,
                      SizedBox(height: 15.0),

                      label("Breve descripción"),
                      SizedBox(height: 10.0),
                      description,
                      SizedBox(height: 15.0),

                      label("Precio por mes"),
                      SizedBox(height: 10.0),
                      price,
                      SizedBox(height: 15.0),

                      label("Términos de renta"),
                      SizedBox(height: 10.0),
                      terms,

                      SizedBox(height: 15.0),
                      //longButtons("Registrar", submit),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                child: longButtons("Aceptar", submit),
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