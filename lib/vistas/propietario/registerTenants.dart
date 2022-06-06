import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/widgets.dart';

import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ihunt/utils/validators.dart';

import 'landlordView.dart';

class RegisterTenant extends StatefulWidget {

  const RegisterTenant({Key key, this.rooms}) : super(key: key);
  final rooms;

  @override
  _RegisterTenantState createState() => _RegisterTenantState();
}


class _RegisterTenantState extends State<RegisterTenant> {
  void setData() async{
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
      //list_rooms = getRooms(id_prop) as List<String>;
    });
  }

  // VARIABLES DE SESION
  User currentUser;
  String id_prop;
  String nombre;
  List<String> list_rooms = [''];

  @override
  void initState(){
    setData();
  }


  final formKey = new GlobalKey<FormState>();

  TextEditingController iduserCtrl = new TextEditingController();
  TextEditingController monthsCtrl = new TextEditingController();
  TextEditingController startdateCtrl = new TextEditingController();
  TextEditingController enddateCtrl = new TextEditingController();
  TextEditingController paydateCtrl = new TextEditingController();
  TextEditingController plazoCtrl = new TextEditingController();
  TextEditingController detailsCtrl = new TextEditingController();


  String _iduser, _room, _contrato, _months, _plazo, _details ;
  String _startdate = "";
  String _enddate = "";
  String _paydate = "";

  bool _saving = false;
  TextStyle style = TextStyle(fontSize: 18);

  final dateFormat = DateFormat("dd-M-yyyy");

  Future getRooms(id) async{
    Api _api = Api();

    var snapShoot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    var _id = snapShoot['usuario'];
    String tokenAuth = await currentUser.getIdToken();

    final msg = jsonEncode({
      "usuario": _id
    });

    var response = await _api.GetRooms(msg, tokenAuth);
    var data = jsonDecode(response.body);
    List<String> _rooms = [];

    if (response.statusCode == 200) {
      // CHECAR BIEN LOS CODIDOS DE RESPUESTA

      data.forEach((index, room) {
        if (room['estatus']==1){
          _rooms.add('idhabitacion');
        }

      });

      return _rooms;
    } else {
      if (Platform.isAndroid) {
        //_materialAlertDialog(context, data['message'], 'Notificación');
        print(response.statusCode);
      } else if (Platform.isIOS) {
        //_cupertinoDialog(context, data['message'], 'Notificación');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final userId = TextFormField(
      autofocus: false,
      controller: iduserCtrl,
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

    final room = DropdownButtonFormField<String>(
      value: _room,
      hint: Text(
        'Seleccione la habitación',
      ),
      onChanged: (value) =>
          setState(() => _room = value),
      validator: (value) => value == null ? 'Por favor elija una opción' : null,
      items:
      widget.rooms['rooms'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    final months = TextFormField(
      autofocus: false,
      controller: monthsCtrl,
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

    final payDate2 = DateTimeFormField(
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
        onSaved: (value) => _paydate = value.toString()
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
        onSaved: (value) => _paydate = value.toString()
    );

    final Plazo = TextFormField(
      autofocus: false,
      controller: plazoCtrl,
      validator: numberValidator,
      onSaved: (value) => _plazo = value,
      decoration:
      buildInputDecoration("Detalles", Icons.more_vert),
    );

    final Details = TextFormField(
      autofocus: false,
      controller: detailsCtrl,
      onSaved: (value) => _details = value,
      decoration:
      buildInputDecoration("Términos", Icons.more_vert),
    );



    /**** VENTANAS DE DIALOGO PARA EL ERROR DE LA API O FORMULARIO****/
    /*
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
    }*/
    /***************************************************************************/

    /*var canceled = () async {
      Navigator.pop(context);
    };*/

    Future registerNewTenant() async {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        var snapShoot = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        var _id = snapShoot['usuario'];
        String tokenAuth = await currentUser.getIdToken();

        final msg = jsonEncode({
          "idusuario": iduserCtrl.text,
          "idhabitacion": _room,
          "idpropietario": _id,
          "contrato": _contrato == 'Sí' ? "1" : "0",
          "meses": int.parse(monthsCtrl.text), // conversion a entero
          "fecha_inicio": _startdate.split(" ")[0],
          "fecha_fin": _enddate.split(" ")[0],
          "fecha_pago": _paydate.split(" ")[0],
          "plazo": int.parse(plazoCtrl.text), // conversion a entero,
          "detalles": detailsCtrl.text
        });
        print(msg);
        Api _api = Api();

        /*Future.delayed(Duration(seconds : 3), () {
          // Do something
          setState(() => _saving = false);
          print(msg);

        });*/


        var response = await _api.RegisterTenantPost(msg, tokenAuth);
        Map data = jsonDecode(response.body);

        print("################# ESTATUS CODE REGISTRO INQUILINO: ${data}");

        print(response.statusCode);

        if (response.statusCode == 201 || response.statusCode == 200) {
          // CHECAR BIEN LOS CODIDOS DE RESPUESTA
          setState(() => _saving = false);
          debugPrint("Data posted successfully");
          Navigator.pop(context);
          /*Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new Landlord())
          );*/
        } else {
          if (Platform.isAndroid) {
            //_materialAlertDialog(context, data['message'], 'Notificación');
            print(response.statusCode);
          } else if (Platform.isIOS) {
           // _cupertinoDialog(context, data['message'], 'Notificación');
          }
        }

      } else {
        setState(() => _saving = false);
        /*
        if (Platform.isAndroid) {
          /*_materialAlertDialog(
              context,
              "Por favor, rellene el formulario correctamente",
              "Formulario inválido");*/
        } else if (Platform.isIOS) {
          /*_cupertinoDialog(
              context,
              "Por favor, rellene el formulario correctamente",
              "Formulario inválido");*/
        }*/
      }
    }

    final registrarTenant = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            setState(() => _saving = true);
            registerNewTenant();
          },
          child: Text("Registrar",
              textAlign: TextAlign.center,
              style: style.copyWith(color: Colors.white)),
        )
    );

    return SafeArea(
        child: Scaffold(
          body: ModalProgressHUD(
            child: Container(
              padding: EdgeInsets.all(20.0),
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

                      label("Seleccione la habitación"),
                      SizedBox(height: 5),
                      room,
                      SizedBox(
                        height: 15,
                      ),

                      label("Indique si hay contrato"),
                      SizedBox(height: 5),
                      contrato,
                      SizedBox(
                        height: 15,
                      ),

                      label("Núm. de meses de contrato"),
                      SizedBox(height: 5.0),
                      months,
                      SizedBox(height: 15.0),

                      label("Fecha de inicio"),
                      SizedBox(height: 5.0),
                      startDate,
                      SizedBox(height: 15.0),

                      label("Fecha de termino"),
                      SizedBox(height: 5.0),
                      endDate,
                      SizedBox(height: 15.0),

                      label("Fecha de pago (el dia es el tomado)"),
                      SizedBox(height: 5.0),
                      payDate,
                      SizedBox(height: 15.0),

                      label("Núm. días máximo de pago"),
                      SizedBox(height: 5.0),
                      Plazo,
                      SizedBox(height: 15.0),

                      label("Detalles de contrato\\renta"),
                      SizedBox(height: 5.0),
                      Details,
                      SizedBox(height: 35.0),

                      registrarTenant,
                      //longButtons("Registrar", submit),
                      /*Row(
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
                      ),*/
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
            inAsyncCall: _saving,
          ),
        ),
    );
  }

}