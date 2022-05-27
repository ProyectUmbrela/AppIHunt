import 'dart:convert';
import 'dart:io';
import 'dart:ui';
//import 'package:carousel_slider/carousel_slider.dart';
///import 'package:flutter/gestures.dart';
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

//import 'landlordView.dart';

class RegisterRoom extends StatefulWidget {
  @override
  _RegisterRoomState createState() => _RegisterRoomState();
}


class _RegisterRoomState extends State<RegisterRoom> {

  String selectedCountry;
  int _currentstep = 0;
  var addressCompound = '';
  var estadoCompound = '';
  var municipioCompound = '';
  String selectedValueCP = null;
  TextStyle style = TextStyle(fontSize: 18);

  TextEditingController roomidCtrl = new TextEditingController();
  TextEditingController cpCtrl = new TextEditingController();
  TextEditingController dimensionsCtrl = new TextEditingController();
  TextEditingController servicesCtrl = new TextEditingController();
  TextEditingController descriptionCtrl = new TextEditingController();
  TextEditingController priceCtrl = new TextEditingController();
  TextEditingController termsCtrl = new TextEditingController();
  String _roomid, _cpInput, _colonia, _dimensions, _services, _description, _price, _terms;





  @override
  Widget build(BuildContext context) {

    final roomId = TextFormField(
      autofocus: false,
      controller: roomidCtrl,
      validator: (value) => value.isEmpty ? "Your roomId is required" : null,
      onSaved: (value) => _roomid = value,
      decoration: buildInputDecoration("room name", Icons.airline_seat_individual_suite),
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



    final registrarRoom = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            //setState(() => _saving = true);
            //_sendRequest(myControllerEmail, myControllerPassword);
            //
          },
          child: Text("Registrar",
              textAlign: TextAlign.center,
              style: style.copyWith(color: Colors.white)),
        )
    );


    return SafeArea(
        child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            //key: formKey,
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    label("Habitación"),
                    SizedBox(height: 5,),
                    roomId,
                    SizedBox(height: 15,),
                    /***********************/
                    label("Dirección"),
                    SizedBox(height: 5),
                    direccion(),
                    SizedBox(height: 15,),
                    /***********************/
                    label("Dimensión de la habitación"),
                    SizedBox(height: 5,),
                    dimensions,
                    SizedBox(height: 15,),
                    /***********************/
                    label("Servicios incluidos"),
                    SizedBox(height: 5,),
                    services,
                    SizedBox(height: 15,),
                    /***********************/
                    label("Detalles adicionales"),
                    SizedBox(height: 5,),
                    description,
                    SizedBox(height: 15,),
                    /***********************/
                    label("Costo mensual"),
                    SizedBox(height: 5,),
                    price,
                    SizedBox(height: 15,),
                    /***********************/
                    label("Términos de renta"),
                    SizedBox(height: 5,),
                    terms,
                    /***********************/
                    SizedBox(height: 35,),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: MaterialButton(
                              color: Color(0xFFE0E0E0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: () {
                                _imgFromGallery();


                              },
                              child: Text("Seleccionar imagen",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0, color: Colors.black)
                              ),
                            ))
                      ],
                    ),
                    /***********************/
                    SizedBox(height: 55,),
                    /***********************/
                    registrarRoom,
                  ],
              )
            ),
          ),
        )
    ));
  }

  // ENVIAR DATOS PARA REGISTRAR HABITACION
  Future sendRoom() async{

  }

  List<File> imageFileList = [];

  final ImagePicker _picker = ImagePicker();

  // OBTENER IMAGENES DE LA GALERIA
  _imgFromGallery() async {


    var images = await _picker.pickMultiImage();
    images.forEach((image) {
      setState(() {
        imageFileList.add(File(image.path));
      });
    });
  }





  // STEPPER PARA OBTENER LA DIRECCION
  Widget direccion(){

    return Row(
        children: [
          Expanded(
            child: Stepper(
              physics : ClampingScrollPhysics(),
              steps: _mySteps(),
              currentStep: this._currentstep,
              onStepTapped: (step) {
                setState(() {
                  this._currentstep = step;
                });
              },
              onStepContinue: () {
                setState(() {
                  if (this._currentstep < this._mySteps().length - 1) {
                    this._currentstep = this._currentstep + 1;
                  } else {
                    print('completed, check field');
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (this._currentstep > 0) {
                    this._currentstep = this._currentstep - 1;
                    selectedCountry = null; //****************************************
                  } else {
                    this._currentstep = 0;
                  }
                });
              },
            ),
          ),
        ],
    );
  }


  // OBTIENE LOS MUINICIPIOS Y LOCALIDADES DADO UN CODIGO POSTAL VALIDO
  Future getCp() async {

    //***************************************
    //***************************************
    //***************************************
    // codigo postal no valido: 62557
    //***************************************
    //***************************************
    //***************************************



    Api _api = Api();

    String cp_value = await cpCtrl.text;
    if ((cp_value.isNotEmpty) && (cp_value.length == 5)){
      print("******************************* A VALUE HAS BEEN RECEIVED: ${cp_value}");
      final msg = jsonEncode({
        "cp": cp_value //cpCtrl.text
      });

      var response = await _api.GetAddress(msg);
      int statusCode = response.statusCode;

      if(statusCode == 201){

        var data = jsonDecode(response.body);
        var estado = jsonDecode(data['Direcciones']);
        List<String> listAsentamientosCustom = [];
        estado.forEach((key, value) {
          var newresult = estado['municipios'][0];
          for (var asentamiento in newresult['asentamientos']) {
            for (var item in asentamiento['asentamiento']) {
              if (!listAsentamientosCustom.contains(item)) {
                listAsentamientosCustom.add(item);
              }
            }
          }
        });

        print("========> ${listAsentamientosCustom}");
        /*
        List<String> listAsentamientos = [
          "Amarena Residencial",
          "Residencial Aria",
          "El Baldaquin Residencial",
          "Aquitania",
          "Residencial San Salvador",
          "Villas Kent Seccion Guadalupe",
          "ISSEMYM la Providencia",
          "Azaleas",
          "Azaleas I y II",
          "Los Sauces",
          "Normandia",
          "El Pueblito",
          "Rinconada San Luis",
          "Sur de La Hacienda",
          "Villas Kent Seccion el Nevado",
          "Villas Santa Teresa",
          "Villas Tizatlalli",
          "Santa Cecilia",
          "Estrella",
          "Galapagos",
          "San Antonio",
          "Habitat Metepec",
          "Quintas de San Jeronimo",
          "Paseo Santa Elena",
          "Santa Rita",
          "Villa los Arrayanes I",
          "Villa los Arrayanes II",
          "Villas Country",
          "San Miguel",
          "El Pirul",
          "La Capilla",
          "Los Cisnes",
          "Real de Azaleas I",
          "Rinconada Mexicana",
          "Alsacia",
          "Explanada del Parque",
          "Lorena",
          "La Asuncion",
          "Rancho San Lucas",
          "Real de Azaleas III",
          "Santa Maria Regla",
          "Palma Real",
          "Rinconada la Concordia",
          "Altavista",
          "Haciendas de Guadalupe",
          "San Salvador Tizatlalli",
          "Esperanza Lopez Mateos",
          "Agricola Francisco I. Madero",
          "Bellavista",
          "Árbol de la Vida"
        ];*/

        listAsentamientosCustom.sort();
        return listAsentamientosCustom;

      }
      else{
        print("############ ERROR GENERADO CODIGO POSTAL NO VALIDO: ${response}");
        return [];
      }
    }else{
      print("####################### ERROR CON EL CODIGO POSTAL: ${cp_value}");
      return [];
    }
  }


  // GENERA LA LISTA DE RESULTADOS OBTENIDOS EN getCp() FUNCTION
  Widget projectWidget() {

    return FutureBuilder(
      future: getCp(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          // Esperando la respuesta de la API
          return SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );
          /*return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ]
            ),
          );*/
        }
        else if(snapshot.hasData && snapshot.data.isEmpty) {
          // Informacion obtenida de la API pero esta vacio el response
          return DropdownButtonFormField(
            items: [''].map<DropdownMenuItem<String>>((String value) {
              return  DropdownMenuItem(
                value: 'null',
                child: Text('null')
              );
            }).toList(),
          );
        }
        else  {
          // Informacion obtenida y con datos en el response
          return DropdownButtonFormField(
            //decoration: new InputDecoration(icon: Icon(Icons.language)),
            hint: Text("Colonia o asentamiento"),
            value: selectedCountry,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
              ),
            items: snapshot.data.map<DropdownMenuItem<String>>((String country) {
              return  DropdownMenuItem(
                value: country,
                child: Text(country, style: TextStyle(color: Color.fromRGBO(58, 66, 46, .9))),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() => selectedCountry = newValue);
              selectedCountry = newValue;
            },
          );
        }
      },
    );
  }

  // LISTA DE PASOS DENTRO DE DIRECCION
  List<Step> _mySteps() {

    List<Step> _steps = [
      Step(
          title:  Text(_currentstep == 0 ? 'Código postal': ''),
          content: TextFormField(
            controller: cpCtrl,
            onSaved: (value) => _cpInput = value,
            decoration: InputDecoration(
              hintText: 'Código postal',
              border: OutlineInputBorder(),
            ),
          ),
          isActive: _currentstep >= 0,
          state: _currentstep == 0 ? StepState.editing: StepState.complete
      ),
      Step(
          title: Text(_currentstep == 1 ? 'Localidad': ''),
          content: projectWidget(),
          isActive: _currentstep >= 1,
          state: _currentstep == 1 ? StepState.editing: StepState.complete
      ),
      Step(
          title: Text(_currentstep == 2 ? 'Calle': ''),
          content: TextFormField(
            decoration: InputDecoration(
              hintText: 'Calle y num',
              border: OutlineInputBorder(),
            ),
          ),
          isActive: _currentstep >= 2,
          state: _currentstep == 2 ? StepState.editing: StepState.complete
      ),
    ];

    return _steps;
  }













  /*
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
  TextEditingController cpCtrl = new TextEditingController();
  TextEditingController dimensionsCtrl = new TextEditingController();
  TextEditingController servicesCtrl = new TextEditingController();
  TextEditingController descriptionCtrl = new TextEditingController();
  TextEditingController priceCtrl = new TextEditingController();
  TextEditingController termsCtrl = new TextEditingController();
  String _roomid, _cp, _colonia, _dimensions, _services, _description, _price, _terms;

  // VARIABLES PARA COORDENADAS
  double lat;
  double lngt;
  int _index = 0;
  String _state = '';
  String selectedValueCP = null;
  String selectedValueColonia = null;
  List<DropdownMenuItem> items = [];

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
  // OBTENER LATITUD Y LONGITUD


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




  Future getCp() async {
    Api _api = Api();

    final msg = jsonEncode({
      "cp": "62570" //cpCtrl.text
    });

    var response = await _api.GetAddress(msg);
    var data = jsonDecode(response.body);

    Map<String, Object> respuesta = {
      'Direcciones': {
        'estado': 'Morelos',
        'municipios': [
          {
            'municipio': 'Jiutepec',
            'asentamientos': [
              {
                'tipo_asentamiento': 'Colonia',
                'asentamiento': [
                  'Pedregal de Tejalpa',
                  'Oriental',
                  'Tejalpa',
                  'Ampliacion Tejalpa',
                  'Vicente Guerrero',
                  'Ampliacion Vicente Guerrero',
                  'Atenatitlan',
                  'Cuauhtemoc Cardenas',
                  'Los Pinos Tejalpa',
                  'San Isidro',
                  'Deportiva',
                  'El Capiri',
                  'Josefa Ortiz de Dominguez'
                ]
              },
              {
                'tipo_asentamiento': 'Unidad habitacional',
                'asentamiento': [
                  'Las Torres',
                  'Real el Cazahuate',
                  'Villas de Cortes'
                ]
              }
            ]
          }
        ]
      }
    };

    data = jsonDecode(respuesta['Direcciones']);

    _state = data['estado'];

    print('---------- CP INGRESADO: ${cpCtrl.text} ${response.statusCode} ${data}');
    List<String> asentamientos = [
      'Morelos'
    ];

    setState(() {
      items = asentamientos.map((item) => DropdownMenuItem(child: Text(item), value: item.toString())).toList();
    });

    return asentamientos;
  }


  Future<List<DropdownMenuItem<String>>> getDropDownItems() async {
    List<DropdownMenuItem<String>> dropdownItems = [];

    List<String> asentamientos = [
      'Morelos'
    ];


    int value = 0;
    for (String currency in asentamientos) {
      print("1 ########################################### ${currency}");
      if(value != asentamientos.length){
        dropdownItems.add(new DropdownMenuItem(
          child: Text(currency,
            style: TextStyle(fontSize: 12),),
          value: currency,
        ));
      }else{
        break;
      }
      value += 1;
    }

    return dropdownItems;
  }


  /*
    final cp = TextFormField(
      autofocus: false,
      controller: cpCtrl,
      validator: (value) => value.isEmpty ? "Ingresa el código postal" : null,
      onSaved: (value) => _cp = value,
      decoration: buildInputDecoration("Dirección", Icons.map),
    );
    */

  /*
    final colonias = DropdownButtonFormField<String>(
      value: _colonia,
      hint: Text(
        'Seleccione un municipio',
      ),
      onChanged: (value) =>
          setState(() => _colonia = value),
      validator: (value) => value == null ? 'Por favor elija una opción' : null,
      items: dropdownItems/*[''].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),*/
    );
    */





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

      await getLocation('');

      var body = {
        "idhabitacion": roomidCtrl.text,
        "idpropietario": _id,
        "direccion": '',
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
        print('######################### ${image_files}');
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
  }*/

  /*
  @override
  Widget build(BuildContext context) {

    final roomId = TextFormField(
      autofocus: false,
      controller: roomidCtrl,
      validator: (value) => value.isEmpty ? "Your roomId is required" : null,
      onSaved: (value) => _roomid = value,
      decoration: buildInputDecoration("room name", Icons.airline_seat_individual_suite),
    );

    var CodigoPostal = TextFormField(
      autofocus: false,
      controller: cpCtrl,
      validator: (value) => value.isEmpty ? "Ingresa el código postal" : null,
      onSaved: (value) => _cp = value,
      decoration: buildInputDecoration("Dirección", Icons.map),
    );

    var colonias = DropdownButtonFormField(
        hint: Text(
          'Seleccione un municipio',
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
        ),
        validator: (value) => value == null ? "Select a country" : null,
        value: selectedValueCP,
        onChanged: (newValue) {
          print("******************************** Selecionada: ${selectedValueCP}");
          setState(() {
            selectedValueCP = newValue;
          });
        },
        items: items //dropdownItems
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



    final address_ = Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 0) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: Text('Ingresa el código postal'),
          content: Container(
              alignment: Alignment.centerLeft,
              child: CodigoPostal
          ),
        ),
        Step(
          title: Text('Estado y Municipio'),
          content: Container(
              alignment: Alignment.centerLeft,
              child: colonias
          ),
        ),
        Step(
          title: Text('Colonia'),
          content: Container(
              alignment: Alignment.centerLeft,
              child: colonias
          ),
        )
      ],
    );

    var canceled = () async {
      Navigator.pop(context);
    };

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
                      address_,
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
  }*/

}