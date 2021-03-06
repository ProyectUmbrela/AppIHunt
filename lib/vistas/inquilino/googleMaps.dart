
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// slider images
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

// style map
import 'package:flutter/services.dart' show rootBundle;
import 'package:geocoder/geocoder.dart';



// to get the current location
//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class MyMaps extends StatefulWidget {
  @override
  MapsPage createState() => MapsPage();
}

class infoHabitacion{
  String servicios;
  String costo;
  String detalles;
  String direccion;
  int habitaciones;
  String titular;


  infoHabitacion(
  this.servicios,
  this.costo,
  this.detalles,
  this.direccion,
  this.habitaciones,
  this.titular);

}


class MapsPage extends State<MyMaps> {

  String _mapStyle;
  String _coleccion = "marker_rent"; // habitaciones

  //google controller and markers
  GoogleMapController _controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  BitmapDescriptor _mapMarker;
  double zoomView = 14.0;



  void setCustomMarker() async {
    _mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'assets/marker_1.png');
  }


  /*
  void _getCurrentLocation() async {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = position;
      //_child = _mapWidget();
    });
  }*/


  void initMarker(position, specifyId, habitacion, setFotos) async{


    final MarkerId markerId = MarkerId(specifyId);
    infoHabitacion info = habitacion;

    double sizeText = 14;

    final Marker marker = new Marker(
      markerId: markerId,
      position: position,
      icon: _mapMarker,
      //onTap: ()=> {},
      infoWindow: InfoWindow(
        snippet: "Ver más detalles",
        title: "Habitación en Renta",
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext builderContext) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 1.0,
                      child: Card(
                        //color: Colors.grey[400],
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CarouselSlider(
                                  options: CarouselOptions(
                                      autoPlay: true
                                  ),
                                  items: setFotos
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget> [
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "\$ ${info.costo} mensual",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: 'Roboto',
                                                    letterSpacing: 0.5,
                                                    fontSize: sizeText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  "Titular: ${info.titular}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: 'Roboto',
                                                    letterSpacing: 0.5,
                                                    fontSize: sizeText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        Text(
                                          "Incluye: ${info.servicios}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.5,
                                            fontSize: sizeText,
                                          ),
                                        ),
                                        Text(
                                          "Detalles: ${info.detalles}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.5,
                                            fontSize: sizeText,
                                          ),
                                        ),
                                        Text(
                                          "Dirección: ${info.direccion}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.5,
                                            fontSize: sizeText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        })
    );

    _markers[markerId] = marker;

  }


  LatLng initCameraPosition;

  CameraPosition _currentPosition;


  /*
  static final CameraPosition initCameraPosition = CameraPosition(

      target: LatLng(18.9242095, -99.21812706731137),
      zoom: 14.0
  );*/


  //GET THE CURRENT POSITION
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
                                            desiredAccuracy: LocationAccuracy.high,
                                            timeLimit: const Duration (seconds: 1));

    //print("POSITION ################: ${position} ###############################");

    setState(() {
        initCameraPosition = LatLng(position.latitude ?? 0, position.longitude ?? 0);

    });

  }


  void setStyleMap() async{
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }
  bool loading;

  void initState(){
    super.initState();
    setStyleMap();
    setCustomMarker();
    _getGeoLocationPosition();

  }

  final TextEditingController _controllerSearch = new TextEditingController();

  Future searchPlace() async {
    try{
      if(_controllerSearch.text.length != 0){
        print("#################################### ${_controllerSearch.text}");

        var results = await Geocoder.local.findAddressesFromQuery(_controllerSearch.text);
        var first = results.first;
        print("################################################");
        print("${first.featureName} : ${first.coordinates}");
        print("################################################");
        var latLng = LatLng(first.coordinates.latitude, first.coordinates.longitude);

        _controller.animateCamera(
            CameraUpdate.newLatLngZoom(
                latLng,
                zoomView
            )
        );
      }
    }
    catch(e) {
      print("Error occured: $e");
    }
  }

  //######################################################################
  //######################################################################
  //######################################################################

  // https://coderedirect.com/questions/412857/cant-load-current-location-in-flutter-application

  //######################################################################
  //######################################################################
  //######################################################################


  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children:
          <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              color: Colors.grey[100],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      controller: _controllerSearch,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          hintText: "Buscar..."),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      splashColor: Colors.black,
                      icon: Icon(Icons.search),
                      onPressed: () => searchPlace()
                    ),
                  ),
                ],
              ),
            )
          ]
        ),
      ) ,//FloatAppBar(_controller),
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection(_coleccion)
                .where("coords", isNotEqualTo: "")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for(int i = 0; i < snapshot.data.docs.length; i++){
                  List<Widget> widgets = [];

                  int hasImage = snapshot.data.docs[i]['check_images'];
                  int publicar = snapshot.data.docs[i]['publicar'];

                  // Si tiene imagenes y se quiere publicar
                  if (hasImage == 1 && publicar == 1){
                      var rawFotos = snapshot.data.docs[i]['fotos'];
                      rawFotos.forEach((final String key, final value) {
                        widgets.add(Image.memory(base64Decode(value)));
                      });

                  }
                  //Si no tiene imagenes
                  else{
                    // si no tiene imagenes pero se quiere publicar usando una imagen default
                    if (publicar == 1){
                      FirebaseFirestore
                          .instance
                          .collection(_coleccion)
                          .doc("NotAvailable")
                          .get()
                          .then((docRef) => {
                        widgets.add(Image.memory(base64Decode(docRef.get('image'))))
                      });
                    }
                    // si no tiene imagenes y no se quiere publicar
                    else{
                      continue;
                    }
                  }

                  double lat = snapshot.data.docs[i]['coords'].latitude;
                  double lng = snapshot.data.docs[i]['coords'].longitude;


                  var latLng = LatLng(lat, lng);

                  String direccion = snapshot.data.docs[i]['direccion'];
                  //String telefono = snapshot.data.docs[i]['telefono'];
                  String titular = snapshot.data.docs[i]['titular'];
                  String servicios = snapshot.data.docs[i]['servicios'];
                  String costo = snapshot.data.docs[i]['costo'];
                  String detalles = snapshot.data.docs[i]['detalles'];

                  int habitaciones = snapshot.data.docs[i]['habitaciones'];


                  infoHabitacion habitacion = infoHabitacion(
                      servicios,
                      costo,
                      detalles,
                      direccion,
                      habitaciones,
                      titular);

                  initMarker(
                      latLng,
                      snapshot.data.docs[i].id,
                      habitacion,
                      widgets);

                }
                return GoogleMap(
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: initCameraPosition,
                      zoom: 14.0),
                  markers: Set<Marker>.of(_markers.values),
                  onMapCreated: _onMapCreated,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )
    );
  }

  void _onMapCreated(GoogleMapController controller){
    _controller = controller;
    controller.setMapStyle(_mapStyle);

  }

}
