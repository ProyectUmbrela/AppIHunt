// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_d
/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ihunt/vistas/userView.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:location_permissions/location_permissions.dart';
import 'package:location/location.dart' as LocationManager;
*/

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}




class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> listMarkers = {};
  BitmapDescriptor customIcon;

  var permission = LocationPermissions().requestPermissions();
  

  Future<LatLng> getUserLocation() async {
    LocationManager.LocationData currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.9242095, -99.21812706731137),
    zoom: 14.4746,
    
  );

  Future backToUser() async {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserView()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: BackButton(
         // icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserView()))
            }
        ), 
        title: Text("Volver"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
        compassEnabled: true),
    );
  }
}
*/