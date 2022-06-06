import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ihunt/vistas/propietario/rooms.dart';
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
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'landlordView.dart';

class UpdateRoom extends StatefulWidget {

  const UpdateRoom({Key key, this.room}) : super(key: key);
  final room;

  @override
  _UpdateRoomState createState() => _UpdateRoomState();
}


class _UpdateRoomState extends State<UpdateRoom> {

  void setData() async{

    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
      roomidCtrl = new TextEditingController(text: widget.room['idhabitacion']);
      adressCtrl = new TextEditingController(text: widget.room['direccion']);
      dimensionsCtrl = new TextEditingController(text: widget.room['dimension']);
      servicesCtrl = new TextEditingController(text: widget.room['servicios']);
      descriptionCtrl = new TextEditingController(text: widget.room['descripcion']);
      priceCtrl = new TextEditingController(text: widget.room['precio'].toString());
      termsCtrl = new TextEditingController(text: widget.room['terminos']);
      //statusCtrl = new TextEditingController(text: widget.room['status']);
    });
  }

  // VARIABLES DE SESION
  User currentUser;
  String id_usuario;
  String nombre;
  TextEditingController roomidCtrl;
  TextEditingController adressCtrl;
  TextEditingController dimensionsCtrl;
  TextEditingController servicesCtrl;
  TextEditingController descriptionCtrl;
  TextEditingController priceCtrl;
  TextEditingController termsCtrl;
  //TextEditingController statusCtrl;

  // VARIABLE DE IMAGENES
  List<File> image_files = []; //new List();
  TextStyle style = TextStyle(fontSize: 15);
  bool _saving = false;


  @override
  void initState(){
    setData();
  }


  final formKey = new GlobalKey<FormState>();

  /*TextEditingController roomidCtrl = new TextEditingController();
  TextEditingController adressCtrl = new TextEditingController();
  TextEditingController dimensionsCtrl = new TextEditingController();
  TextEditingController servicesCtrl = new TextEditingController();
  TextEditingController descriptionCtrl = new TextEditingController();
  TextEditingController priceCtrl = new TextEditingController();
  TextEditingController termsCtrl = new TextEditingController();*/

  String _roomid, _adress, _dimensions, _services, _description, _price, _terms, _status;

  // VARIABLES PARA COORDENADAS
  double lat;
  double lngt;

  @override
  Widget build(BuildContext context) {
    // OBTENER LATITUD Y LONGITUD
    /*void getLocation(address) async{
      try {
        var locations = await locationFromAddress(address);
        lat = locations[0].latitude;
        lngt = locations[0].longitude;
      } catch(err){
        lat = 46.8597000;
        lngt = -97.2212000;
      }
    }*/

    /*
    // OBTENER IMAGENES
    _imgFromGallery() async {


    }
    _images_to_base64() async{
      var dicc = {

      };
      for (int i = 0; i < image_files.length; i++){
        final bytes = image_files[i].readAsBytesSync();
        String img64 = base64Encode(bytes);
        dicc[i] = img64;
      }
    }*/


    Future submit() async {
      setState(() => _saving = true);
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();
        Api _api = Api();

        var snapShoot = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        var _userid = snapShoot['usuario'];
        var name = snapShoot['nombre'];
        String tokenAuth = await currentUser.getIdToken();

        final msg = jsonEncode({
          "idhabitacion": roomidCtrl.text,
          "idpropietario": _userid,
          "direccion": adressCtrl.text,
          "dimension": dimensionsCtrl.text,
          "servicios": servicesCtrl.text,
          "descripcion": descriptionCtrl.text,
          "precio": double.parse(priceCtrl.text),
          "terminos": termsCtrl.text
        });

        //////////await getLocation(adressCtrl.text);

        print("body actualizar habitacion ${msg}");
        //addDocument(lat, lngt, priceCtrl.text, descriptionCtrl.text, adressCtrl.text, servicesCtrl.text, name);

        var response = await _api.UpdateRoom(msg, tokenAuth);
        Map data = jsonDecode(response.body);
        print("#################################################");
        print("#################################################");
        print(data);
        print("#################################################");
        print("#################################################");


        if (response.statusCode  == 201) {
          // CHECAR BIEN LOS CODIDOS DE RESPUESTA
          //debugPrint("ACTUALIZACION HABITACION EXITOSA!");
          setState(() => _saving = false);
          _showDialog(2, "Se actualizo la habitación");
          //Navigator.pop(context);
        }
        else if (response.statusCode  == 433){
          setState(() => _saving = false);
          _showDialog(2, "Datos incorrectos");
        }
        else if (response.statusCode  == 501){
          setState(() => _saving = false);
          _showDialog(2, "Error al actualizar los datos");
        }
        else {
          setState(() => _saving = false);
          _showDialog(2, "Ocurrio un error con la solicitud");
          /*if (Platform.isAndroid) {
            //_materialAlertDialog(context, data['message'], 'Notificación');
            print(response.statusCode);
          } else if (Platform.isIOS) {
            print(response.statusCode);
            //_cupertinoDialog(context, data['message'], 'Notificación');
          }*/
        }
      } else {

        /*if (Platform.isAndroid) {
          print("A error");
         /* _materialAlertDialog(
              context,
              "Por favor, rellene el formulario correctamente",
              "Formulario inválido");*/
        } else if (Platform.isIOS) {
          print("B error");
          /*_cupertinoDialog(
              context,
              "Por favor, rellene el formulario correctamente",
              "Formulario inválido");*/
        }*/
      }
    }
    /*
    void addDocument(latitude, longitude, price, description, address, services, name) async{
      final now = new DateTime.now();
      String date = DateFormat('yMd').format(now);// 28/03/2020

      var document = {
        'coords' : new GeoPoint(latitude=latitude, longitude=longitude),
        'costo': price,
        'detalles': description,
        'direccion': address,
        'fotos': {},
        'habitaciones': 1,
        'servicios': services,
        'titular': name
      };

      // AGREGAR IMAGENES STR
      for (int i = 0; i < image_files.length; i++){
        final bytes = image_files[i].readAsBytesSync();
        String img64 = base64Encode(bytes);
        document['fotos'][i.toString()] = img64;
      }

    }*/

    final roomId = TextFormField(
      autofocus: false,
      controller: roomidCtrl,
      enabled: false,
      validator: (value) => value.isEmpty ? "ID de habitación requerido" : null,
      onSaved: (value) => _roomid = value,
      decoration: buildInputDecoration("room name", Icons.airline_seat_individual_suite),
    );

    final adress = TextFormField(
      autofocus: false,
      controller: adressCtrl,
      enabled: widget.room['status'] == 1 ? false : true,
      validator: (value) => value.isEmpty ? "La dirección es requerida" : null,
      onSaved: (value) => _adress = value,
      decoration:
      buildInputDecoration("Dirección", Icons.map),
    );

    final dimensions = TextFormField(
      autofocus: false,
      controller: dimensionsCtrl,
      enabled: true,
      validator: (value) => value.isEmpty ? "La dimensión de la habitacón es requerida" : null,
      onSaved: (value) => _dimensions = value,
      decoration: buildInputDecoration("Dimensión", Icons.menu),
    );

    final services = TextFormField(
      autofocus: false,
      controller: servicesCtrl,
      enabled: widget.room['status'] == 1 ? false : true,
      onSaved: (value) => _services = value,
      decoration: buildInputDecoration("Servicios", Icons.local_laundry_service),
    );

    final description = TextFormField(
      autofocus: false,
      controller: descriptionCtrl,
      enabled: widget.room['status'] == 1 ? false : true,
      onSaved: (value) => _description = value,
      decoration:
      buildInputDecoration("Descripción", Icons.description),
    );

    final price = TextFormField(
      autofocus: false,
      controller: priceCtrl,
      validator: numberValidator,
      enabled: widget.room['status'] == 1 ? false : true,
      onSaved: (value) => _price = value,
      decoration:
      buildInputDecoration("Precio", Icons.monetization_on),
    );

    final terms = TextFormField(
      autofocus: false,
      controller: termsCtrl,
      enabled: widget.room['status'] == 1 ? false : true,
      onSaved: (value) => _terms = value,
      decoration:
      buildInputDecoration("Términos", Icons.add_alert),
    );

    final actualizarRoom = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: 110.0,//MediaQuery.of(context).size.width/5,
          height: 45.0,
          //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            //setState(() => _saving = true);
            //registerNewRoom();
            submit();
          },
          child: Text("Actualizar",
              textAlign: TextAlign.center,
              style: style.copyWith(color: Colors.white)),
        )
    );

    final eliminarRoom = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: 110.0,//MediaQuery.of(context).size.width/5,
          height: 45.0,
          //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            setState(() => _saving = true);
            deleteRoom(id_usuario, roomidCtrl.text);
          },
          child: Text("Eliminar",
              textAlign: TextAlign.center,
              style: style.copyWith(color: Colors.white)),
        )
    );


    /*
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
    }*/
    /***************************************************************************/

    /*
    var canceled = () async {
      Navigator.pop(context);
      /*Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new Landlord(),
        ),
      );*/
    };*/



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

                      label("Id habitación"),
                      SizedBox(height: 5),
                      roomId,
                      SizedBox(height: 15,),

                      label("Dirección"),
                      SizedBox(height: 5),
                      adress,
                      SizedBox(height: 15,),

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

                      label("Costo mensual"),
                      SizedBox(height: 10.0),
                      price,
                      SizedBox(height: 15.0),

                      label("Términos de renta"),
                      SizedBox(height: 10.0),
                      terms,

                      SizedBox(height: 45.0),
                      //longButtons("Registrar", submit),
                      //actualizarRoom,
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                child: actualizarRoom,
                                alignment: Alignment.centerLeft,
                              )),
                          Expanded(
                              child: Container(
                                child: eliminarRoom,
                                alignment: Alignment.centerRight,
                              )),
                        ],
                      ),
                      SizedBox(height: 25.0),

                      /*
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: MaterialButton(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () {
                                  _imgFromGallery();
                                },
                                child: Text(
                                  "selccionar imagen",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ),
                        ],
                      ),*/
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

  Future deleteRoom(id_usuario, idhabitacion) async{
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ${widget.room['status']}");

    /*
    if (widget.room['status'] == 1){
      print("************************** Habitacion rentada actualmente");
      setState(() => _saving = false);

      _showDialog(2, "La habitación se encuentra ocupada");
    }
    else if(widget.room['status'] == 0){
      print("************************** Habitacion no ocupada");
      setState(() => _saving = false);
      _showDialog(2, "Se elimino la habitación");
    }*/


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
      //debugPrint("################## HABITACION ELIMINADA CORRECTAMENTE DE FIRESTORE Y MYSQL");
      setState(() => _saving = false);
      _showDialog(2, "Se elimino la habitación");

      /*Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new Landlord(),
          ),
        );*/
      //Navigator.of(context).pop();
    }
    else if (response.statusCode == 433) {
      setState(() => _saving = false);
      _showDialog(2, "Datos incorrectos");
    }
    else if (response.statusCode == 425) {
      setState(() => _saving = false);
      _showDialog(2, "La habitación está ocupada");
    }
    else if (response.statusCode == 504){
      setState(() => _saving = false);
      _showDialog(2, "Error al intentar eliminar");
    }
    else {
      setState(() => _saving = false);
      _showDialog(2, "Ocurrio un error en la solicitud");
    }

  }





}