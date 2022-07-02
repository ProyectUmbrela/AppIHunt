import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:ihunt/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ihunt/providers/provider.dart';

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
  double lat;
  double lngt;

  // VARIABLE DE IMAGENES
  List<File> image_files = [];
  TextStyle style = TextStyle(fontSize: 15);
  bool _saving = false;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState(){
    setData();
  }

  String _roomid, _adress, _dimensions, _services, _description, _price, _terms, _status;

  @override
  Widget build(BuildContext context) {

    Future updateARoom() async {
      setState(() => _saving = true);
      final form = formKey.currentState;

      if (form.validate()) {
        // actalizar almenos un campo para enviar la solicitud
        if(adressCtrl.text == widget.room['direccion'] &&
            dimensionsCtrl.text == widget.room['dimension'] &&
            servicesCtrl.text == widget.room['servicios'] &&
            descriptionCtrl.text == widget.room['descripcion'] &&
            priceCtrl.text == widget.room['precio'].toString() &&
            termsCtrl.text == widget.room['terminos']){

          print("No hay cambio de datos..........");
          setState(() => _saving = false);
          _showDialog(2, "No hay datos a actualizar");
        }
        else{
          print("hay cambio de datos..........");
          form.save();
          Api _api = Api();
          var snapShoot = await FirebaseFirestore
              .instance
              .collection(GlobalDataLandlord().userCollection)
              .doc(currentUser.uid)
              .get();

          var _userid = snapShoot['usuario'];
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

          var response = await _api.UpdateRoom(msg, tokenAuth);
          Map data = jsonDecode(response.body);
          print("#################################################");
          print("#################################################");
          print(data);
          print("#################################################");
          print("#################################################");


          if (response.statusCode == 201) {
            // CHECAR BIEN LOS CODIDOS DE RESPUESTA
            setState(() => _saving = false);
            _showDialog(2, "Se actualizo la habitación");

          }
          else if (response.statusCode == 433){
            setState(() => _saving = false);
            _showDialog(2, "Datos incorrectos");
          }
          else if (response.statusCode == 501){
            setState(() => _saving = false);
            _showDialog(2, "Error al actualizar los datos");
          }
          else {
            _showDialog(2, "Ocurrio un error con la solicitud");
          }

        }

      } else {
        setState(() => _saving = false);
      }
    }

    final roomId = TextFormField(
      autofocus: false,
      controller: roomidCtrl,
      enabled: false,
      //validator: (value) => value.isEmpty ? "ID de habitación requerido" : null,
      onSaved: (value) => _roomid = value,
      decoration: buildInputDecoration("ID", Icons.airline_seat_individual_suite),
    );

    final adress = TextFormField(
      autofocus: false,
      controller: adressCtrl,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(150),
      ],
      enabled: widget.room['status'] == 1 ? false : true,
      validator: (value) => value.isEmpty ? "La dirección es requerida" : null,
      onSaved: (value) => _adress = value,
      decoration: buildInputDecoration("Dirección", Icons.map),
    );

    final dimensions = TextFormField(
      autofocus: false,
      controller: dimensionsCtrl,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(30),
      ],
      enabled: true,
      validator: (value) => value.isEmpty ? "La dimensión de la habitacón es requerida" : null,
      onSaved: (value) => _dimensions = value,
      decoration: buildInputDecoration("Dimensión", Icons.menu),
    );

    final services = TextFormField(
      autofocus: false,
      controller: servicesCtrl,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(150),
      ],
      enabled: widget.room['status'] == 1 ? false : true,
      onSaved: (value) => _services = value,
      decoration: buildInputDecoration("Servicios", Icons.local_laundry_service),
    );

    final description = TextFormField(
      autofocus: false,
      controller: descriptionCtrl,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(150),
      ],
      enabled: widget.room['status'] == 1 ? false : true,
      onSaved: (value) => _description = value,
      decoration: buildInputDecoration("Descripción", Icons.description),
    );

    final price = TextFormField(
      autofocus: false,
      controller: priceCtrl,
      validator: numberValidator,
      enabled: widget.room['status'] == 1 ? false : true,
      onSaved: (value) => _price = value,
      decoration: buildInputDecoration("Precio", Icons.monetization_on),
    );

    final terms = TextFormField(
      autofocus: false,
      controller: termsCtrl,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(150),
      ],
      enabled: widget.room['status'] == 1 ? false : true,
      onSaved: (value) => _terms = value,
      decoration: buildInputDecoration("Términos", Icons.add_alert),
    );

    final actualizarRoom = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,//150.0,
          height: 45.0,
          onPressed: () {
            updateARoom();
          },
          child: Text("Actualizar",
              textAlign: TextAlign.center,
              style: style.copyWith(color: Colors.white)),
        ),
    );

    final eliminarRoom = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade500, //Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,//110.0,
          height: 45.0,
          onPressed: () {
            _displayDialogForDelete(context);
          },
          child: Text("Eliminar",
              textAlign: TextAlign.center,
              style: style.copyWith(color: Colors.white)),
        ),
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
                      actualizarRoom,
                      SizedBox(height: 10.0),
                      eliminarRoom,
                      /*Row(
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
                      ),*/
                      SizedBox(height: 15.0),
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

  _displayDialogForDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('¿Seguro que deseas eliminar esta habitación?'),
            actions: <Widget>[
              new FlatButton(
                child: Text('Eliminar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  setState(() => _saving = true);
                  await deleteRoom(id_usuario, roomidCtrl.text);
                },
              ),
            ],
          );
        });
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


    Api _api = Api();

    var snapShoot = await FirebaseFirestore
        .instance
        .collection(GlobalDataLandlord().userCollection)
        .doc(currentUser.uid)
        .get();
    var _userid = snapShoot['usuario'];
    String tokenAuth = await currentUser.getIdToken();

    final msg = jsonEncode({
      "usuario": _userid,
      "idhabitacion": idhabitacion
    });

    var response = await _api.DeleteRoomPost(msg, tokenAuth);
    //var data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      // CREAR UN REFRESH EN LA PAGINA
      setState(() => _saving = false);
      _showDialog(2, "Se elimino la habitación");

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