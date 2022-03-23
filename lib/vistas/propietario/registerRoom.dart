import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:ihunt/utils/widgets.dart';
import 'package:intl/intl.dart';

/////////////////////////////////////////import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'landlordView.dart';

class RegisterRoom extends StatefulWidget {
  @override
  _RegisterRoomState createState() => _RegisterRoomState();
}


class _RegisterRoomState extends State<RegisterRoom> {
  void setData() async{
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  // VARIABLES DE SESION
  User currentUser;
  String id_usuario;
  String nombre;

  // VARIABLE DE IMAGENES
  List<File> image_files = new List();

  @override
  void initState(){
    setData();
  }


  final formKey = new GlobalKey<FormState>();

  TextEditingController roomidCtrl = new TextEditingController();
  TextEditingController adressCtrl = new TextEditingController();
  TextEditingController dimensionsCtrl = new TextEditingController();
  TextEditingController servicesCtrl = new TextEditingController();
  TextEditingController descriptionCtrl = new TextEditingController();
  TextEditingController priceCtrl = new TextEditingController();
  TextEditingController termsCtrl = new TextEditingController();

  String _roomid, _adress, _dimensions, _services, _description, _price, _terms;

  // VARIABLES PARA COORDENADAS
  double lat;
  double lngt;

  @override
  Widget build(BuildContext context) {

    // OBTENER LATITUD Y LONGITUD
    void getLocation(address) async{
      try {
        var locations = await locationFromAddress(address);
        lat = locations[0].latitude;
        lngt = locations[0].longitude;
      } catch(err){
        lat = 46.8597000;
        lngt = -97.2212000;
      }
    }

    // OBTENER IMAGENES
    _imgFromGallery() async {
      File image = await ImagePicker.pickImage(
          source: ImageSource.gallery);

      setState(() {
        image_files.add(image);
        print("########################## ############## LOGITUD DE LISTA ${image_files.length}");
      });
    }
   _images_to_base64() async{
      var dicc = {

      };
      for (int i = 0; i < image_files.length; i++){
        final bytes = image_files[i].readAsBytesSync();
        String img64 = base64Encode(bytes);
        dicc[i] = img64;
      }
    }

    void addDocument(latitude, longitude, price, description, address, services, name, id_room) async{
      final now = new DateTime.now();
      String date = DateFormat('yMd').format(now);// 28/03/2020

      if(image_files.length == 0){
        var document = {
          'coords' : new GeoPoint(latitude=latitude, longitude=longitude),
          'costo': price,
          'detalles': description,
          'direccion': address,
          'check_images': 0,
          'habitaciones': 1,
          'servicios': services,
          'titular': name
        };

        await FirebaseFirestore.instance
            .collection("habitaciones")
            .doc(id_room)
            .set(
            {
              'coords' : new GeoPoint(latitude=latitude, longitude=longitude),
              'costo': price,
              'detalles': description,
              'direccion': address,
              'check_images': 0,
              'habitaciones': 1,
              'publicar': 1,
              'disponibilidad': 0,
              'servicios': services,
              'titular': name
            },
            SetOptions(merge: true)
            );
      }else{
        var document = {
          'coords' : new GeoPoint(latitude=latitude, longitude=longitude),
          'costo': price,
          'detalles': description,
          'direccion': address,
          'check_images': 1,
          'fotos': {},
          'publicar': 1,
          'disponibilidad': 0,
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
        await FirebaseFirestore.instance
            .collection("habitaciones")
            .doc(id_room)
            .set(document,
            SetOptions(merge: true)
        );
      }
    }

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
      onSaved: (value) => _services = value,
      decoration: buildInputDecoration("Servicios", Icons.local_laundry_service),
    );

    final description = TextFormField(
      autofocus: false,
      controller: descriptionCtrl,
      onSaved: (value) => _description = value,
      decoration:
      buildInputDecoration("Descripción", Icons.description),
    );

    final price = TextFormField(
      autofocus: false,
      controller: priceCtrl,
      validator: numberValidator,
      onSaved: (value) => _price = value,
      decoration:
      buildInputDecoration("Precio", Icons.monetization_on),
    );

    final terms = TextFormField(
      autofocus: false,
      controller: termsCtrl,
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
      Navigator.pop(context);
      /*Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new Landlord(),
        ),
      );*/
    };

    Future submit() async {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();
        Api _api = Api();

        var snapShoot = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        var _id = snapShoot['usuario'];
        var _name = snapShoot['nombre'];
        String tokenAuth = await currentUser.getIdToken();

        await getLocation(adressCtrl.text);

        var body = {
          "idhabitacion": roomidCtrl.text,
          "idpropietario": _id,
          "direccion": adressCtrl.text,
          "dimension": dimensionsCtrl.text,
          "servicios": servicesCtrl.text,
          "descripcion": descriptionCtrl.text,
          "precio": double.parse(priceCtrl.text),
          "terminos": termsCtrl.text,
          'latitud' : lat,
          "longitud": lngt,
          'publicar': 1,
          'disponibilidad': 0,
          'fotos': {}
        };

        if (image_files.length == 0){

          body['check_images'] = 0;

        }else{

          body['check_images'] = 1;
          // AGREGAR IMAGENES STR
          for (int i = 0; i < image_files.length; i++){
            final bytes = image_files[i].readAsBytesSync();
            print('++++++++++++++++++ IMAGEN ${i}');
            //String img64 = base64Encode(bytes);
            //body['fotos'][i.toString()] = img64;
          }

        }

        final msg = jsonEncode(body);
        print(' *********************** MSG ${msg}');
        //addDocument(lat, lngt, priceCtrl.text, descriptionCtrl.text, adressCtrl.text, servicesCtrl.text, _name, roomidCtrl.text);


        var response = await _api.RegisterRoomPost(msg, tokenAuth);
        print('------------------- RESPUESTA ${response.statusCode}');
        Map data = jsonDecode(response.body);

        if (response.statusCode == 201) {
          // CHECAR BIEN LOS CODIDOS DE RESPUESTA
          Navigator.pop(context);
          /*Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new Landlord())
          );*/
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
                      ),

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
                              ))
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

}