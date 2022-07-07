import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart' show rootBundle;
//import 'streambuilder_test.dart';


class MyAppMaps extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppMaps> {
  GoogleMapController _mapController;
  String _mapStyle;
  //TextEditingController _latitudeController, _longitudeController;

  // firestore init
  final radius = BehaviorSubject<double>.seeded(1.0);
  final _firestore = FirebaseFirestore.instance;
  final markers = <MarkerId, Marker>{};

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
      final collectionReference = _firestore.collection('marker_rent');

      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);

      /*
      ****Example to specify nested object****

      var collectionReference = _firestore.collection('nestedLocations');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'address.location.position');

      */
    });


  }

  @override
  void dispose() {
    //_latitudeController?.dispose();
    //_longitudeController?.dispose();
    radius.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        /*
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return StreamTestWidget();
            }));
          },
          child: Icon(Icons.navigate_next),
        ),*/
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: mediaQuery.size.width - 10,
                    height: mediaQuery.size.height * 0.69,// * (1 / 2),
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
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: TextField(
                      controller: _latitudeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: 'lat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: TextField(
                      controller: _longitudeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'lng',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      final lat =
                      double.parse(_latitudeController?.text ?? '0.0');
                      final lng =
                      double.parse(_longitudeController?.text ?? '0.0');
                      _addPoint(lat, lng);
                    },
                    child: const Text(
                      'ADD',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),*/
              /*
              MaterialButton(
                color: Colors.amber,
                child: const Text(
                  'Add nested ',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  final lat = double.parse(_latitudeController?.text ?? '0.0');
                  final lng = double.parse(_longitudeController?.text ?? '0.0');
                  _addNestedPoint(lat, lng);
                },
              ),*/
            ],
          ),
        ),
    );
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

  /*
  void _addPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore
        .collection('habitaciones_prueba')
        .add({'name': 'random name', 'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }
  */


  //example to add geoFirePoint inside nested object
  /*
  void _addNestedPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('nestedLocations').add({
      'name': 'random name',
      'address': {
        'location': {'position': geoFirePoint.data}
      }
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }
  */


  void _addMarker(double lat, double lng) {
    final id = MarkerId(lat.toString() + lng.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print("11111111111111111111111111111111111111111111111 ${documentList.length}");
    documentList.forEach((DocumentSnapshot document) {
      print("************* ${document} ************************");
      final data = document.data() as Map<String, dynamic>;
      final GeoPoint point = data['position']['geopoint'];
      _addMarker(point.latitude, point.longitude);
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

}