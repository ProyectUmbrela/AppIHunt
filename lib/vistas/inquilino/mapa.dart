// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_d
/*
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';

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

*/

  /*
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
  */

  /*
  List<String> links_document = [];



  Future<void> listExample(String document) async {
    print("Initi");

    // document = '2vttDFuJU2pjBqiYhnL6';
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref(document).listAll();



    result.items.forEach((firebase_storage.Reference ref) async {
      print('Found file: $ref');
      //downloadURLExample(ref);

      final link = await ref.getDownloadURL();
      print("===> $link");
      links_document.add(link);

    });

    /*result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });*/

    print("CCCCCCCCCCCCCCCCCCCCC");

  }


  @override
  Widget build(BuildContext context) {


  String document = '2vttDFuJU2pjBqiYhnL6';

    return Scaffold(
      appBar: AppBar(

        title: Text("Volver"),

      ),
      body: Container(
        child: FloatingActionButton(
          onPressed: ()=> listExample(document),
        )
      )
    );
  }
}
*/

