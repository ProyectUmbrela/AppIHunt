import 'dart:convert';
//import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/widgets.dart';
import 'package:date_field/date_field.dart';
//import 'package:ihunt/vistas/propietario/tenants.dart';
//import 'package:ihunt/vistas/propietario/rooms.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:ihunt/providers/provider.dart';

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
    plazoCtrl.text = '1'; // initial value
  }


  final formKey = new GlobalKey<FormState>();

  TextEditingController iduserCtrl = new TextEditingController();
  TextEditingController monthsCtrl = new TextEditingController();
  TextEditingController startdateCtrl = new TextEditingController();
  TextEditingController enddateCtrl = new TextEditingController();
  TextEditingController paydateCtrl = new TextEditingController();
  TextEditingController plazoCtrl = new TextEditingController();
  TextEditingController detailsCtrl = new TextEditingController();


  String _iduser, _room, _contrato, _months, _plazo, _details;
  //String _paydate = "";

  bool _saving = false;
  TextStyle style = TextStyle(fontSize: 18);
  final dateFormat = DateFormat("dd-M-yyyy");


  @override
  Widget build(BuildContext context) {

    final userId = TextFormField(
      autofocus: false,
      controller: iduserCtrl,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(30),
      ],
      validator: (value) => value.isEmpty ? "Ingresa el usuario que deseas registrar" : null,
      onSaved: (value) => _iduser = value,
      decoration: buildInputDecoration("iduser", Icons.person_add),
    );


    final room = DropdownButtonFormField<String>(
      value: _room,
      hint: Text(
        'Habitación',
      ),
      onChanged: (value) =>
          setState(() => _room = value),
      validator: (value) => value == null ? 'Elije una opción' : null,
      items: widget.rooms['rooms'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    final contrato = DropdownButtonFormField<String>(
      value: _contrato,
      hint: Text(
        'Indica si existe contrato por meses',
      ),
      onChanged: (value) =>
          setState(() => _contrato = value),
      validator: (value) => value == null ? 'Elije una opción' : null,
      items: ['Sí', 'No'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    final months = TextFormField(
      enabled: _contrato == 'Sí' ? true : false,
      autofocus: false,
      controller: monthsCtrl,
      ////////////////////////////validator: numberValidator,
      onSaved: (value) => _months = value,
      decoration: buildInputDecoration("Meses", Icons.more_vert),
    );


    final startDate = DateTimeFormField(
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black45),
        errorStyle: TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.event_note),
      ),
      dateFormat: DateFormat.yMMMMd('es'),
      mode: DateTimeFieldPickerMode.date,
      autovalidateMode: AutovalidateMode.always,
      validator: StartDateValidator,//(e) => ((e?.day ?? 0) == 1) ? 'Fecha inválida' : null,
      onDateSelected: (DateTime value) {

        startdateCtrl.text = value.toString();
        print("|startdateCtrl| ************************** ${startdateCtrl.text}");
      },
      //onSaved: (value) => _startdate = value.toString()
    );

    /*
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
    );*/

    final endDate = DateTimeFormField(
      //enabled: _contrato == 'Sí' ? true : false,
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
        validator: (value) => validateDates(value, startdateCtrl.text),
        //validator: (e) => (e?.day ?? 0) == 1 ? 'Fecha inválida' : null,
        onDateSelected: (DateTime value) {
          enddateCtrl.text = value.toString();
          print("|enddateCtrl|************************** ${enddateCtrl.text}");
        },
        //onSaved: (value) => _enddate = value.toString()
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
        //validator: (e) => (e?.day ?? 0) == 1 ? 'Fecha inválida' : null,
        validator: StartDateValidator,
        onDateSelected: (DateTime value) {
          paydateCtrl.text = value.toString();
          print("|paydateCtrl|************************** ${paydateCtrl.text}");
        },
        //onSaved: (value) => _paydate = value.toString()
    );

    final Plazo = TextFormField(
      autofocus: false,
      controller: plazoCtrl,
      validator: numberValidator,
      onSaved: (value) => _plazo = value,
      decoration: buildInputDecoration("Detalles", Icons.more_vert),
    );

    final Details = TextFormField(
      autofocus: false,
      controller: detailsCtrl,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(150),
      ],
      onSaved: (value) => _details = value,
      decoration: buildInputDecoration("Términos", Icons.more_vert),
    );

    Future registerNewTenant() async {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        var snapShoot = await FirebaseFirestore
            .instance
            .collection(GlobalDataLandlord().userCollection)
            .doc(currentUser.uid)
            .get();
        var _userid = snapShoot['usuario'];
        String tokenAuth = await currentUser.getIdToken();

        final msg = jsonEncode({
          "idusuario": iduserCtrl.text,
          "idhabitacion": _room,
          "idpropietario": _userid,
          "contrato": _contrato == 'Sí' ? "1" : "0",
          "meses": monthsCtrl.text == null ? int.parse(monthsCtrl.text) : 0, // conversion a entero
          "fecha_inicio": startdateCtrl.text.split(" ")[0],
          "fecha_fin": enddateCtrl.text.split(" ")[0],
          "fecha_pago": paydateCtrl.text != null ? paydateCtrl.text.split(" ")[0] : "null",
          "plazo": int.parse(plazoCtrl.text), // conversion a entero,
          "detalles": detailsCtrl.text
        });
        print("*****************************************************************");
        print("*****************************************************************");
        print(msg);
        print("*****************************************************************");
        print("*****************************************************************");


        Api _api = Api();
        var response = await _api.RegisterTenantPost(msg, tokenAuth);

        if (response.statusCode == 201 || response.statusCode == 200) {
          // CHECAR BIEN LOS CODIDOS DE RESPUESTA

          form.reset();
          clearForm();
          setState(() => _saving = false);
          _showDialog(2, 'Invitación enviada');
        }
        else if (response.statusCode == 425){
          setState(() => _saving = false);
          _showDialog(2, 'Usuario inválido');
        }
        else if (response.statusCode == 430){
          setState(() => _saving = false);
          _showDialog(2, 'No existe la habitación');
        }
        else if (response.statusCode == 402){
          setState(() => _saving = false);
          _showDialog(2, 'Límite de invitaciones superado');
        }
        else if (response.statusCode == 408){
          setState(() => _saving = false);
          _showDialog(2, 'La habitación ya se encuentra ocupada');
        }
        else {
          setState(() => _saving = false);
          _showDialog(2, 'Ocurrio un error en tu solicitud');
        }

      } else {
        setState(() => _saving = false);
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

                      label("ID de usuario"),
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

                      label("Indica si hay contrato"),
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

                      label("Fecha 1er pago (el dia es el tomado)"),
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
  void clearForm() {

    _room = null;
    _contrato = null;
    iduserCtrl.clear();
    monthsCtrl.clear();
    plazoCtrl.clear();
    detailsCtrl.clear();
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

}