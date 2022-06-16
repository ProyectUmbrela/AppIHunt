import 'dart:convert';
import 'dart:io';
//import 'package:ihunt/vistas/propietario/rooms.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ihunt/providers/api.dart';
import 'package:ihunt/utils/validators.dart';
import 'package:ihunt/utils/widgets.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:permission_handler/permission_handler.dart';


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
  final formKey = new GlobalKey<FormState>();
  final multiPicker = ImagePicker();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  bool _saving = false;
  TextStyle style = TextStyle(fontSize: 18);


  TextEditingController roomidCtrl = new TextEditingController();
  TextEditingController cpCtrl = new TextEditingController();
  TextEditingController addressCtrl = new TextEditingController();
  TextEditingController dimensionsCtrl = new TextEditingController();
  TextEditingController servicesCtrl = new TextEditingController();
  TextEditingController descriptionCtrl = new TextEditingController();
  TextEditingController priceCtrl = new TextEditingController();
  TextEditingController termsCtrl = new TextEditingController();
  String _roomid, _cpInput, _colonia, _dimensions, _services, _description, _price, _terms, _addressInput;
  String _stateSelected;
  String _municipioSelected;
  int maxImages = 8;


  User currentUser;
  String id_usuario;
  String nombre;

  void setData() async{
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  void initState(){
    setData();
  }

  @override
  Widget build(BuildContext context) {

    final roomId = TextFormField(
      autofocus: false,
      controller: roomidCtrl,
      validator: (value) => value.isEmpty ? "ID de habitación requerido" : null,
      onSaved: (value) => _roomid = value,
      decoration: buildInputDecoration("room name", Icons.airline_seat_individual_suite),
    );

    final dimensions = TextFormField(
      autofocus: false,
      controller: dimensionsCtrl,
      validator: (value) => value.isEmpty ? "La dimensión es requerida" : null,
      onSaved: (value) => _dimensions = value,
      decoration: buildInputDecoration("Dimensión", Icons.menu),
    );

    final services = TextFormField(
      autofocus: false,
      controller: servicesCtrl,
      validator: (value) => value.isEmpty ? "Añade los servicios incluidos" : null,
      onSaved: (value) => _services = value,
      decoration: buildInputDecoration("Servicios", Icons.local_laundry_service),
    );

    final description = TextFormField(
      autofocus: false,
      controller: descriptionCtrl,
      onSaved: (value) => _description = value,
      decoration: buildInputDecoration("Descripción", Icons.description),
    );

    final price = TextFormField(
      autofocus: false,
      controller: priceCtrl,
      validator: numberValidator,
      onSaved: (value) => _price = value,
      decoration: buildInputDecoration("Precio", Icons.monetization_on),
    );

    final terms = TextFormField(
      autofocus: false,
      controller: termsCtrl,
      onSaved: (value) => _terms = value,
      decoration: buildInputDecoration("Términos", Icons.add_alert),

    );

    final registrarRoom = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            setState(() => _saving = true);
            registerNewRoom();
          },
          child: Text("Registrar",
              textAlign: TextAlign.center,
              style: style.copyWith(color: Colors.white)),
        )
    );

    final addingPhotos = InkWell(
      onTap: () {
        selectImages();
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 5),
          itemCount: imageFileList.length,
          itemBuilder: (context, index) => Container(
            height: 100,
            width: 120,
            margin: EdgeInsets.only(left: 3.0, right: 3.0),
            child: imageFileList.length > 0 ?
            Container(
                decoration:
                BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(File(imageFileList[index].path)),
                      fit: BoxFit.cover
                  ),
                ),
            ): Icon(
                  Icons.camera,
                  color: Colors.blue,
                ),
            /*Icon(
              CupertinoIcons.camera,
              color: Colors.blue,
              //.withOpacity(0.5),
            ),*/
          ),
        ),
      ),
    );
    //print("=============> ${imageFileList.length}");
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
                            SizedBox(height: 15,),
                            /***********************/
                            addingPhotos,
                            /***********************/
                            Center(child: Text("Adjuntar imagénes"),),
                            SizedBox(height: 35,),
                            /***********************/
                            registrarRoom,
                            SizedBox(height: 15,),
                          ],
                      ),
                    ),
                  ),
              ),
              inAsyncCall: _saving,
            ),
    ));
  }


  Future insertIntoMysql(a_document, tokenAuth) async{

    Api _api = Api();
    final body = jsonEncode(a_document);
    var response = await _api.RegisterRoomPost(body, tokenAuth);

    return response.statusCode;

  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState((){});
  }

  // ENVIAR DATOS PARA REGISTRAR HABITACION
  Future registerNewRoom() async{

    final form = formKey.currentState;

    if (form.validate()) {

      var fullAddress = '${toBeginningOfSentenceCase(addressCtrl.text)}, ${selectedCountry}, ${cpCtrl.text} ${_municipioSelected}, ${_stateSelected}';

      if (imageFileList.length <= maxImages){
        form.save();
        // preparando imagenes para codificar
        List<String> images64_Base = [];
        _images_to_base64() async {
          for (int i = 0; i < imageFileList.length; i++) {
            List<int> imageBytes = await imageFileList[i].readAsBytes();
            String img64 = base64Encode(imageBytes);
            images64_Base.add(img64);
          }
        }

        // generando las imagenes en base64
        await _images_to_base64();

        // generando las coordenadas sobre la direccion proporcionada
        var coordinates = await getLocation(fullAddress);
        if (coordinates != null){
          var snapShoot = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
          var _iduser = snapShoot['usuario'];
          String tokenAuth = await currentUser.getIdToken();


          var generalDocument = {
            'idhabitacion': roomidCtrl.text,
            'idpropietario': _iduser,
            'direccion': fullAddress,
            'dimension': dimensionsCtrl.text,
            'servicios': servicesCtrl.text,
            'descripcion': descriptionCtrl.text,
            'precio': priceCtrl.text,
            'terminos': termsCtrl.text,
            'latitud': coordinates.latitude,
            'longitud': coordinates.longitude,
            'publicar': 1,
            'disponibilidad': 1,
            'fotos': {},
            'check_images': 1
          };

          if(images64_Base.isNotEmpty) {
            for (int i = 0; i < images64_Base.length; i++) {
              generalDocument['fotos'][i.toString()] = images64_Base[i];
            }
          }

          var responseCode = await insertIntoMysql(generalDocument, tokenAuth);
          print("######### RESPONSE: ${responseCode}");
          if(responseCode == 201){
            clearForm();
            setState(() => _saving = false);
            _showDialog(2, "Habitación registrada");
          }
          else if(responseCode == 438){
            setState(() => _saving = false);
            _showDialog(2, "Ya existe la habitación");
          }
          else if(responseCode == 432){
            setState(() => _saving = false);
            _showDialog(2, "No se localiza el usuario");
          }
          else if(responseCode == 422){
            setState(() => _saving = false);
            _showDialog(2, "Datos incorectos");
          }
          else{
            setState(() => _saving = false);
            _showDialog(2, "Ocurrio un error con la solicitud");
          }
        }else{
          setState(() => _saving = false);
          _showDialog(2, "No se encuentra la dirección");
        }
      }
      else {
        setState(() => _saving = false);
        _showDialog(2, "Máximo ocho imagénes");
      }
    }else{
      setState(() => _saving = false);
    }
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
      List<String> listAsentamientosCustom = [];

      print("******************************* A VALUE HAS BEEN RECEIVED: ${cp_value}");
      final msg = jsonEncode({
        "cp": cp_value //cpCtrl.text
      });

      var response = await _api.GetAddress(msg);
      int statusCode = response.statusCode;

      if (statusCode == 201) {
        var data = jsonDecode(response.body);
        var estado = jsonDecode(data['Direcciones']);
        //
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

        _stateSelected = estado['estado'];
        _municipioSelected = estado['municipios'][0]['municipio'];
        listAsentamientosCustom.sort();
        return listAsentamientosCustom;

      }
      else if (statusCode == 412){
        _showDialog(2, 'Código postal inválido');
        return [];
      } else{
        _showDialog(2, 'Datos incorrectos');
        return [];
      }
    }
    else{
      return [];
    }
  }


  // GENERA LA LISTA DE RESULTADOS OBTENIDOS EN getCp() FUNCTION
  Widget projectWidget() {

    return FutureBuilder(
      future: getCp(),
      builder: (context, snapshot) {
        //if(!snapshot.hasData){
        if(!snapshot.hasData){// || snapshot.connectionState == ConnectionState.waiting){
          // Esperando la respuesta de la API
          return Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
          );
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
            validator: (String value) {
              if (value == null || value.isEmpty) {
                return 'Localidad requerido';
              }
              return null;
            },
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
              validator: (value) {
                if (value == null || value.isEmpty || value.length != 5) {
                  return 'Código postal requerido';
                }
                return null;
              }
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
            controller: addressCtrl,
            onSaved: (value) => _addressInput = value,
            decoration: InputDecoration(
              hintText: 'Calle y num',
              border: OutlineInputBorder(),
            ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Calle y Núm requerido';
                }
                return null;
              }
          ),
          isActive: _currentstep >= 2,
          state: _currentstep == 2 ? StepState.editing: StepState.complete
      ),
    ];

    return _steps;
  }

  Future getLocation(address) async{
    try {
      var locations = await locationFromAddress(address);
      return locations[0];
    } catch(err){
      return null;
    }
  }

  void clearForm() {

    roomidCtrl.clear();
    cpCtrl.clear();
    addressCtrl.clear();
    dimensionsCtrl.clear();
    servicesCtrl.clear();
    descriptionCtrl.clear();
    priceCtrl.clear();
    termsCtrl.clear();
  }



}