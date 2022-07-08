import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../providers/provider.dart';
//import 'streambuilder_test.dart';


class MyAppMaps extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppMaps> {
  GoogleMapController _mapController;
  String _mapStyle;
  //TextEditingController _latitudeController, _longitudeController;
  LatLng initCameraPosition;
  // firestore init
  final TextEditingController _controllerSearch = new TextEditingController();
  final radius = BehaviorSubject<double>.seeded(1.0);
  final _firestore = FirebaseFirestore.instance;
  final markers = <MarkerId, Marker>{};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<List<DocumentSnapshot>> stream;
  Geoflutterfire geo;

  void setStyleMap() async{
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  void initState() {
    super.initState();
    setStyleMap();
    // _latitudeController = TextEditingController();
    // _longitudeController = TextEditingController();

    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: 18.9242095, longitude: -99.22156590000002);
    stream = radius.switchMap((rad) {
      final collectionReference = _firestore
          .collection('marker_rent');

      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);

    });
  }

  @override
  void dispose() {
    //_latitudeController?.dispose();
    //_longitudeController?.dispose();
    radius.close();
    super.dispose();
  }

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

      else if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        //lat=6.9271;long=79.8612;
        initCameraPosition = LatLng(7.4219983, -122.084);
      }
      else{
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

    // Latitude: 37.4219983, Longitude: -122.084


    return position;
  }

  Widget getViewWidget(_markers) {

    return FutureBuilder(
        future: _getGeoLocationPosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            LatLng Currentposition;
            // Latitude: 37.4219983
            // Longitude: -122.084
            if (!snapshot.hasData){
              Currentposition  =  LatLng(37.4219983 , -122.084);
            }
            else{
              Currentposition  =  LatLng(snapshot.data.latitude , snapshot.data.longitude);
            }
            return GoogleMap(
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              myLocationEnabled: true,
              compassEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: Currentposition, //LatLng(37.4219983 , -122.084),
                  zoom: 14.0),
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: _onMapCreated,
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children:
          <Widget>[
            Container(
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          hintText: "Buscar"),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                        splashColor: Colors.black,
                        icon: Icon(
                          Icons.search,
                          color: Colors.black54,),
                        onPressed: () => searchPlace()
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          width: mediaQuery.size.width - 5,
                          height: mediaQuery.size.height * 0.61,// * (1 / 2),
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(18.9242095, -99.22156590000002),
                              zoom: 15.0,
                            ),
                            markers: Set<Marker>.of(markers.values),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Slider(
                        min: 1,
                        max: 200,
                        divisions: 4,
                        value: _value,
                        label: _label,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue.withOpacity(0.2),
                        onChanged: (double value) => changed(value),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );

          },
        ),
      ),
      /*body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Card(
                elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: mediaQuery.size.width - 5,
                    height: mediaQuery.size.height * 0.61,// * (1 / 2),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(18.9242095, -99.22156590000002),
                        zoom: 15.0,
                      ),
                      markers: Set<Marker>.of(markers.values),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Slider(
                  min: 1,
                  max: 200,
                  divisions: 4,
                  value: _value,
                  label: _label,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.withOpacity(0.2),
                  onChanged: (double value) => changed(value),
                ),
              ),
            ],
          ),
        ),*/
    );
  }

  Future searchPlace() async {
    try{
      if(_controllerSearch.text.length != 0){

        var results = await Geocoder.local.findAddressesFromQuery(_controllerSearch.text);
        var first = results.first;
        var latLng = LatLng(first.coordinates.latitude, first.coordinates.longitude);


        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(
              latLng,
              14.0
          ),
        );
        // cargando los marcadores para las nuevas coordenadas
        //changedPosition(20);
      }
    }
    catch(e) {
      print("Error occured: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      controller.setMapStyle(_mapStyle);
//      _showHome();
      //start listening after map is created
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  /*
  void _showHome() {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      const CameraPosition(
        target: LatLng(12.960632, 77.641603),
        zoom: 15.0,
      ),
    ));
  }*/


  void _addMarker(habitacion, List<Widget> widgetsFotos) {

    //final idPublicacion = MarkerId(habitacion.id);
    print("#########################################################################");
    print("#########################################################################");
    print("#########################################################################");
    print("${habitacion['titular']}");
    print("#########################################################################");
    print("#########################################################################");
    print("#########################################################################");
    var fontWords = FontWeight.w500;
    double sizeText = 13;
    final GeoPoint point = habitacion['position']['geopoint'];
    final id = MarkerId(point.latitude.toString() + point.longitude.toString());
    print("####################################################### 1");
    final _marker = Marker(
      markerId: id,
      position: LatLng(point.latitude, point.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      //infoWindow: InfoWindow(title: 'latLng', snippet: '${point.latitude},${point.longitude}'),
      infoWindow: InfoWindow(
          snippet: "Ver más detalles",
          title: "Habitación en Renta",
          onTap: (){
            showDialog(
              context: _scaffoldKey.currentContext,
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
                                      items: widgetsFotos
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
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "\$ ${habitacion['costo']} mensual",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: fontWords,
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
                                            ],
                                          ),
                                          Text(
                                            "Titular: ${habitacion['titular']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: fontWords,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.5,
                                              fontSize: sizeText,
                                            ),
                                          ),
                                          Text(
                                            "Tel: ${habitacion['telefono']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: fontWords,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.5,
                                              fontSize: sizeText,
                                            ),
                                          ),
                                          Text(
                                            "Incluye: ${habitacion['servicios']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: fontWords,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.5,
                                              fontSize: sizeText,
                                            ),
                                          ),
                                          Text(
                                            "Detalles: ${habitacion['detalles']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: fontWords,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.5,
                                              fontSize: sizeText,
                                            ),
                                          ),
                                          Text(
                                            "Dirección: ${habitacion['direccion']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: fontWords,
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
          },
      ),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      List<Widget> widgetsFotos = [];

      final habitacion = document.data() as Map<String, dynamic>;
      int hasImage = habitacion['check_images'];
      int publicar = habitacion['publicar'];

      if (hasImage == 1 && publicar == 1){
        var rawFotos = habitacion['fotos'];
        rawFotos.forEach((final String key, final value) {
          widgetsFotos.add(Image.memory(base64Decode(value)));
        });
      }
      else{
        // si no tiene imagenes pero se quiere publicar usando una imagen default
        if (publicar == 1){
          widgetsFotos.add(Image.memory(base64Decode(GlobalDataUser().notAvailable)));
        }
      }

      // creando los marcadores
      _addMarker(habitacion, widgetsFotos);

    });
  }

  double _value = 20.0;
  String _label = '';


  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }

  changedPosition(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }


}