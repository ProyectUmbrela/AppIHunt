import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:date_field/date_field.dart';
import 'package:ihunt/vistas/propietario/rooms.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:ihunt/utils/widgets.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'landlordView.dart';

class DetailTenant extends StatefulWidget {

  const DetailTenant({Key key, this.tenant}) : super(key: key);
  final tenant;

  @override
  _DetailTenantState createState() => _DetailTenantState();
}


class _DetailTenantState extends State<DetailTenant> {
  void setData() async{
    var sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      nombre = sharedPreferences.getString("nombre") ?? "Error";
      id = sharedPreferences.getString("idusuario") ?? "Error";
    });
  }

  // VARIABLES DE SESION
  String id;
  String nombre;

  @override
  void initState(){
    setData();
  }


  final formKey = new GlobalKey<FormState>();

  String _iduser, _contrato, _months, _startdate, _enddate, _paydate, _plazo, _details ;

  @override
  Widget build(BuildContext context) {

    TextEditingController iduserCtrl = new TextEditingController(text: widget.tenant['idusuario']);
    TextEditingController monthsCtrl = new TextEditingController(text: widget.tenant['']);
    TextEditingController startdateCtrl = new TextEditingController(text: widget.tenant['fechainicontrato']);
    TextEditingController enddateCtrl = new TextEditingController(text: widget.tenant['fechafincontrato']);
    TextEditingController paydateCtrl = new TextEditingController(text: widget.tenant['fechapago']);
    TextEditingController plazoCtrl = new TextEditingController(text: widget.tenant['']);
    TextEditingController detailsCtrl = new TextEditingController(text: widget.tenant['']);

    final userId = TextFormField(
      autofocus: false,
      controller: iduserCtrl,
      enabled: false,
      validator: (value) => value.isEmpty ? "Ingrese el id del usuario a registrar" : null,
      onSaved: (value) => _iduser = value,
      decoration: buildInputDecoration("iduser", Icons.person_add),
    );


    final contrato = DropdownButtonFormField<String>(
      value: _contrato,
      hint: Text(
        'Indique si existe contrato por meses',
      ),
      onChanged: (value) =>
          setState(() => _contrato = value),
      validator: (value) => value == null ? 'Por favor elija una opción' : null,
      items:
      ['Sí', 'No'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    final months = TextFormField(
      autofocus: false,
      controller: monthsCtrl,
      enabled: false,
      validator: numberValidator,
      onSaved: (value) => _months = value,
      decoration: buildInputDecoration("Meses", Icons.more_vert),
    );


    final startDate = DateTimeFormField(
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.event_note),
          //labelText: 'Only time',
        ),
        dateFormat: DateFormat.yMMMMd('es'),
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.always,
        validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
        onDateSelected: (DateTime value) {
          print(value);
        },
        onSaved: (value) => _startdate = value.toString()
    );

    final endDate = DateTimeFormField(
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.event_note),
          //labelText: 'Only time',
        ),
        dateFormat: DateFormat.yMMMMd('es'),
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.always,
        validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
        onDateSelected: (DateTime value) {
          print(value);
        },
        onSaved: (value) => _enddate = value.toString()
    );

    final payDate = DateTimeFormField(
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.event_note),
          //labelText: 'Only time',
        ),
        dateFormat: DateFormat.yMMMMd('es'),
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.always,
        validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
        onDateSelected: (DateTime value) {
          print(value);
        },
        onSaved: (value) => _startdate = value.toString()
    );

    final Plazo = TextFormField(
      autofocus: false,
      controller: plazoCtrl,
      enabled: false,
      validator: numberValidator,
      onSaved: (value) => _plazo = value,
      decoration:
      buildInputDecoration("Detalles", Icons.more_vert),
    );

    final Details = TextFormField(
      autofocus: false,
      controller: detailsCtrl,
      enabled: false,
      onSaved: (value) => _details = value,
      decoration:
      buildInputDecoration("Términos", Icons.more_vert),
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

    Future deleteTenant(id, idhabitacion, idinquilino) async{

      Api _api = Api();

      final msg = jsonEncode({
        "idinquilino": idinquilino,
        "idhabitacion": idhabitacion,
        "idpropietario": id
      });

      var response = await _api.DeleteTenantPost(msg);
      var data = jsonDecode(response.body);
      debugPrint("################## ELIMINAR INQUILINO ${response.statusCode}");

      if (response.statusCode == 201) {
        // CREAR UN REFRESH EN LA PAGINA
        Navigator.pop(context);
      } else {

        if (Platform.isAndroid) {
          //_materialAlertDialog(context, data['message'], 'Notificación');
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

                      label("Ingrese el id del usuario"),
                      SizedBox(height: 5),
                      userId,
                      SizedBox(
                        height: 15,
                      ),

                      label("Indique si hay contrato"),
                      SizedBox(height: 5),
                      contrato,
                      SizedBox(
                        height: 15,
                      ),

                      label("Indique los meses del contrato"),
                      SizedBox(height: 5.0),
                      months,
                      SizedBox(height: 15.0),

                      label("Indique la fecha de inicio"),
                      SizedBox(height: 5.0),
                      startDate,
                      SizedBox(height: 15.0),

                      label("Indique la fecha de fin"),
                      SizedBox(height: 5.0),
                      endDate,
                      SizedBox(height: 15.0),

                      label("Indique la fecha de pago (el dia es el tomado)"),
                      SizedBox(height: 5.0),
                      payDate,
                      SizedBox(height: 15.0),

                      label("Num. días de plazo para el pago"),
                      SizedBox(height: 5.0),
                      Plazo,
                      SizedBox(height: 15.0),

                      label("Detalles de contrato\\renta"),
                      SizedBox(height: 5.0),
                      Details,
                      SizedBox(height: 15.0),
                      //() => deleteTenant(id, snapshot.data[index].idhabitacion, snapshot.data[index].idusuario)
                      Row(
                        children: <Widget>[
                          MaterialButton(
                              onPressed:() => deleteTenant(id, widget.tenant['idhabitacion'], widget.tenant['idusuario']),
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
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

}