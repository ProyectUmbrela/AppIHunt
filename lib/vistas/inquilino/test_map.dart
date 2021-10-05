

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
//import 'dart:async';


// style map
import 'package:flutter/services.dart' show rootBundle;

// to get the current location
//import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class MyMaps extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyHomePage createState() => MyHomePage();
}



class MyHomePage extends State<MyMaps> {




  //style map
  String _mapStyle;

  //google controller and markers
  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor _mapMarker;

  void setCustomMarker() async {
    _mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'assets/marker_1.png');
  }

  void addingMarker(latitude, longitude) async{

    FirebaseFirestore.instance
        .collection("marker_rent").add({
      'coords' : new GeoPoint(latitude=latitude, longitude=longitude)   //[latitude, longitude]
    }).then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

  }

  void initMarker(specify, specifyId) async{

    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
            specify['coords'].latitude,
            specify['coords'].longitude),
        icon: _mapMarker,
        infoWindow: InfoWindow(title: "En renta")
    );
    setState(() {
      markers[markerId] = marker;
    });

  }

  static final CameraPosition initCameraPosition = CameraPosition(
      target: LatLng(18.9242095, -99.21812706731137),
      zoom: 14
  );

  void getMarkerData() async{

    var locations = await locationFromAddress("Civac, Jiutepec, Mor.");
    print("########################################");
    double lat = locations[0].latitude;
    double lngt = locations[0].longitude;
    print("====> lat: ${lat}");
    print("====> lngt: ${lngt}");
    addingMarker(lat, lngt);
    print("########################################");
    FirebaseFirestore.instance
        .collection("marker_rent")
        .where("coords", isNull: false)
        .get()
        .then((myMarkers){
      if (myMarkers.docs.isNotEmpty){
        for (int i=0; i < myMarkers.docs.length; i++){
          print("==> (${myMarkers.docs[i].data()['coords'].latitude} , ${myMarkers.docs[i].data()['coords'].longitude})");
          initMarker(
              myMarkers.docs[i].data(), myMarkers.docs[i].id);
        }
      }
    });
  }

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
    return await Geolocator.getCurrentPosition();
  }


  void setStyleMap() async{
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }


  void initState(){
    getMarkerData();
    super.initState();
    setStyleMap();
    setCustomMarker();
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Habitaciones en renta"),
      ),
      body: GoogleMap(

        myLocationButtonEnabled: true,
        markers: Set<Marker>.of(markers.values),//getMarker(),
        mapType: MapType.normal,
        //compassEnabled: true,
        initialCameraPosition: initCameraPosition/*CameraPosition(
          target: LatLng(18.9242095, -99.21812706731137),
          zoom: 14.0,

        )*/,
        onMapCreated: _onMapCreated,
      ),

    );

    

  }

  void _onMapCreated(GoogleMapController controller){
    _controller = controller;
    controller.setMapStyle(_mapStyle);
  }



}









