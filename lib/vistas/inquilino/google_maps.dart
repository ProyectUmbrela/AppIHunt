
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ihunt/vistas/inquilino/userView.dart';
import 'dart:async';

// slider images
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

// style map
import 'package:flutter/services.dart' show rootBundle;

// to get the current location
//import 'package:geocoding/geocoding.dart';
//import 'package:geolocator/geolocator.dart';


class MyMaps extends StatefulWidget {
  // This widget is the root of your application.
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

  //google controller and markers
  GoogleMapController _controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  BitmapDescriptor _mapMarker;

  void setCustomMarker() async {
    _mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'assets/marker_1.png');
  }

  /*
  Future backToUser() async {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserView()),
    );
  }*/


  void initMarker(position, specifyId, habitacion, setFotos) async{

    final MarkerId markerId = MarkerId(specifyId);
    infoHabitacion info = habitacion;

    double sizeText = 14;

    final Marker marker = new Marker(
      markerId: markerId,
      position: position,
      icon: _mapMarker,
      onTap: ()=> {
      },
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



  static final CameraPosition initCameraPosition = CameraPosition(
      target: LatLng(18.9242095, -99.21812706731137),
      zoom: 14
  );


  //GET THE CURRENT POSITION
  /*
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
    return await Geolocator.getCurrentPosition();
  }*/


  void setStyleMap() async{
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }


  void initState(){
    super.initState();
    setStyleMap();
    setCustomMarker();
  }



  @override
  Widget build(BuildContext context){
    Set<Marker> markers = Set();

    return Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection("marker_rent")
                .where("coords", isNotEqualTo: "")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                for(int i = 0; i < snapshot.data.docs.length; i++){
                  List<Widget> widgets = [];
                  var rawFotos = snapshot.data.docs[i]['fotos'];

                  if (rawFotos.length == 0 ){

                    FirebaseFirestore
                        .instance
                        .collection("marker_rent")
                        .doc("NotAvailable")
                        .get()
                        .then((docRef) => {
                          widgets.add(Image.memory(base64Decode(docRef.get('image'))))
                    });
                  }

                  else{
                    rawFotos.forEach((final String key, final value) {

                      widgets.add(Image.memory(base64Decode(value)));
                    });
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
                  initialCameraPosition: initCameraPosition,
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
