import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:ihunt/utils/widgets.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'landlordView.dart';
import 'rooms.dart';

class DetailRoom extends StatefulWidget {

  const DetailRoom({Key key, this.room}) : super(key: key);
  final room;

  @override
  _DetailRoomState createState() => _DetailRoomState();
}


class _DetailRoomState extends State<DetailRoom> {
  void setData() async{
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  // VARIABLES DE SESION
  User currentUser;
  String id;
  String nombre;

  // VARIABLE DE IMAGENES
  List<File> image_files = new List();

  @override
  void initState(){
    setData();
  }


  final formKey = new GlobalKey<FormState>();
  String _roomid, _adress, _dimensions, _services, _description, _price, _terms;

  @override
  Widget build(BuildContext context) {

    TextEditingController roomidCtrl = new TextEditingController(text: widget.room['idhabitacion']);
    TextEditingController adressCtrl = new TextEditingController(text: widget.room['direccion']);
    TextEditingController dimensionsCtrl = new TextEditingController(text: widget.room['dimension']);
    TextEditingController servicesCtrl = new TextEditingController(text: widget.room['servicios']);
    TextEditingController descriptionCtrl = new TextEditingController(text: widget.room['descripcion']);
    TextEditingController priceCtrl = new TextEditingController(text: widget.room['precio'].toString());
    TextEditingController termsCtrl = new TextEditingController(text: widget.room['terminos']);

    final roomId = TextFormField(
      autofocus: false,
      controller: roomidCtrl,
      enabled: false,
      validator: (value) => value.isEmpty ? "Your roomId is required" : null,
      onSaved: (value) => _roomid = value,
      decoration: buildInputDecoration("room name", Icons.airline_seat_individual_suite),
    );

    final adress = TextFormField(
      autofocus: false,
      controller: adressCtrl,
      enabled: false,
      validator: (value) => value.isEmpty ? "La dirección de la habitación es requerida" : null,
      onSaved: (value) => _adress = value,
      decoration:
      buildInputDecoration("Dirección", Icons.map),
    );

    final dimensions = TextFormField(
      autofocus: false,
      controller: dimensionsCtrl,
      enabled: false,
      validator: (value) => value.isEmpty ? "La dimensión de la habitacón es requerida" : null,
      onSaved: (value) => _dimensions = value,
      decoration: buildInputDecoration("Dimensión", Icons.menu),
    );

    final services = TextFormField(
      autofocus: false,
      controller: servicesCtrl,
      enabled: false,
      onSaved: (value) => _services = value,
      decoration: buildInputDecoration("Servicios", Icons.local_laundry_service),
    );

    final description = TextFormField(
      autofocus: false,
      controller: descriptionCtrl,
      enabled: false,
      onSaved: (value) => _description = value,
      decoration:
      buildInputDecoration("Descripción", Icons.description),
    );

    final price = TextFormField(
      autofocus: false,
      controller: priceCtrl,
      validator: numberValidator,
      enabled: false,
      onSaved: (value) => _price = value,
      decoration:
      buildInputDecoration("Precio", Icons.monetization_on),
    );

    final terms = TextFormField(
      autofocus: false,
      controller: termsCtrl,
      enabled: false,
      onSaved: (value) => _terms = value,
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
      Navigator.pushReplacementNamed(context, '/landlord');
    };

    Future deleteRoom(id, idhabitacion) async{

      Api _api = Api();

      var snapShoot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      var _id = snapShoot['usuario'];
      String tokenAuth = await currentUser.getIdToken();

      final msg = jsonEncode({
        "usuario": _id,
        "idhabitacion": idhabitacion
      });

      var response = await _api.DeleteRoomPost(msg, tokenAuth);
      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // CREAR UN REFRESH EN LA PAGINA
        debugPrint("################## HABITACION ELIMINADA CORRECTAMENTE");
        Navigator.pop(context);
        /*Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new Landlord(),
          ),
        );*/
        //Navigator.of(context).pop();
      } else {
        debugPrint("################## ERROR EN ELIMINAR CORRECTAMENTE");
        if (Platform.isAndroid) {
          //_materialAlertDialog(context, data['message'], 'Notificación');
          print(response.statusCode);
        } else if (Platform.isIOS) {
          //_cupertinoDialog(context, data['message'], 'Notificación');
        }

      }
    }

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
                          MaterialButton(
                              onPressed: widget.room['status']==1?
                                () {} :
                                () => deleteRoom(id, widget.room['idhabitacion']),
                              textColor: Colors.white,
                              color: Color(0xff01A0C7),
                              minWidth: 120,
                              child: SizedBox(
                                child: Text(
                                    "Eliminar",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12)
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),

                              )
                          )
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

}