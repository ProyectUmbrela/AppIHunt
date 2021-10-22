// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_d

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






  Future<void> listExample() async {
    print("Initi");


    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref('2vttDFuJU2pjBqiYhnL6').listAll();



    result.items.forEach((firebase_storage.Reference ref) async {
      print('Found file: $ref');
      //downloadURLExample(ref);

      final link = await ref.getDownloadURL();
      print("===> $link");

    });

    /*result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });*/

    print("CCCCCCCCCCCCCCCCCCCCC");

  }

  String img= "ihunt-d9d4c.appspot.com/o/2vttDFuJU2pjBqiYhnL6%2Fa.jpg?alt=media&token=a9d5b8e9-fbc2-43e0-b240-b704e7dd0398";
  //gs://ihunt-d9d4c.appspot.com/2vttDFuJU2pjBqiYhnL6/a.jpg
  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(

        title: Text("Volver"),

      ),
      body: Container(
        child: FloatingActionButton(
          onPressed: ()=> listExample(),
        )
      )
    );
  }
}


