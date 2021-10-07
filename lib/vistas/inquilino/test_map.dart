

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ihunt/vistas/userView.dart';


// style map
import 'package:flutter/services.dart' show rootBundle;

// to get the current location
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class MyMaps extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MapsPage createState() => MapsPage();
}



class MapsPage extends State<MyMaps> {




  //style map
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

  Future backToUser() async {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => User()),
    );
  }


  //void initMarker(specify, specifyId) async{
  void initMarker(position, specifyId, num_hab) async{
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    /*
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
            specify['coords'].latitude,
            specify['coords'].longitude),
        icon: _mapMarker,
        infoWindow: InfoWindow(title: "En renta")
    );*/

    final Marker marker = Marker(
        markerId: markerId,
        position: position,
        icon: _mapMarker,
        infoWindow: InfoWindow(title: "${num_hab} habitaciones en renta")
    );

    //setState(() {
      _markers[markerId] = marker;
    //});

  }

  static final CameraPosition initCameraPosition = CameraPosition(
      target: LatLng(18.9242095, -99.21812706731137),
      zoom: 14
  );

  void getMarkerData() async{

    FirebaseFirestore.instance
        .collection("marker_rent")
        .where("coords", isNull: false)
        .get()
        .then((myMarkers){
      if (myMarkers.docs.isNotEmpty){
        for (int i=0; i < myMarkers.docs.length; i++){
          //print("==> (${myMarkers.docs[i].data()['coords'].latitude} , ${myMarkers.docs[i].data()['coords'].longitude})");
          initMarker(
              myMarkers.docs[i].data(), myMarkers.docs[i].id, 0);
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
    //getMarkerData();
    super.initState();
    setStyleMap();
    setCustomMarker();
  }


  @override
  Widget build(BuildContext context){
  /*
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => {
            Navigator.of(context).pop(),
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>User()))
          },
        ),
        title: Text("Volver"),
      ),
      body: SafeArea(
          child:GoogleMap(
            myLocationButtonEnabled: true,
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            //compassEnabled: true,
            initialCameraPosition: initCameraPosition,
            onMapCreated: _onMapCreated,
          )
      ),
    );*/


    Set<Marker> markers = Set();

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>User()))
            },
          ),
          title: Text("Volver"),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection("marker_rent")
                .where("coords", isNull: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for(int i = 0; i < snapshot.data.docs.length; i++){
                  //print("=====> ${snapshot.data.docs[i].data()}");
                  //print("=====> ${snapshot.data.docs[i].id}");


                  double lat = snapshot.data.docs[i]['coords'].latitude;
                  double lng = snapshot.data.docs[i]['coords'].longitude;
                  var num_hab = snapshot.data.docs[i]['habitaciones'];
                  var latLng = LatLng(lat, lng);

                  /*markers
                      .add(Marker(markerId: MarkerId("poss"), position: latLng));*/

                  initMarker(latLng, snapshot.data.docs[i].id, num_hab);


                }
                // Check if location is valid
                /*if (location == null) {
                  return Text("There was no location data");
                }*/

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
