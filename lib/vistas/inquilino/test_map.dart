
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ihunt/vistas/userView.dart';
import 'dart:async';

// slider images
import 'package:carousel_slider/carousel_slider.dart';

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


  infoHabitacion(
      this.servicios,
      this.costo,
      this.detalles);

}

class Habitacion {
  String direccion;
  String telefono;
  String titular;
  List<infoHabitacion> detalles;

  Habitacion(
      this.direccion,
      this.telefono,
      this.titular,
      this.detalles
      );
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
      MaterialPageRoute(builder: (context) => UserView()),
    );
  }


  /*Widget displayInfoHab(){

    return Card(
      color: Colors.grey[800]
    );

  }*/


  List<String> fotosList = [
    "https://awsrpia.s3.amazonaws.com/habitaciones/199709810_3930934096956302_8955632156523703761_n.jpg",
    "https://awsrpia.s3.amazonaws.com/habitaciones/200093415_107240988265907_2391073375870101507_n.jpg",
    "https://awsrpia.s3.amazonaws.com/habitaciones/201482550_532932834826458_3630072694624410304_n.jpg",
    "https://awsrpia.s3.amazonaws.com/habitaciones/201763526_107240834932589_1701097239284879277_n.jpg",
    "https://awsrpia.s3.amazonaws.com/habitaciones/201822557_532998261486582_8554378459947353905_n.jpg",
    "https://awsrpia.s3.amazonaws.com/habitaciones/202073837_501458407829418_6563349131041000474_n.jpg"
  ];


  //void initMarker(position, specifyId, numHab) async{
  void initMarker(position, specifyId, habitacion) async{

    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    Habitacion hab = habitacion;
    infoHabitacion info = hab.detalles[0];
    double sizeText = 15;

    final Marker marker = new Marker(
      markerId: markerId,
      position: position,
      icon: _mapMarker,
      onTap: ()=> {
      },
      infoWindow: InfoWindow(
        snippet: "Ver más detalles",
        title: "${hab.detalles.length} habitaciones en renta",

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
                      height: MediaQuery.of(context).size.width * 1.1,
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
                                  items: fotosList.map(
                                          (img) => Center(
                                        child: Image.network(
                                          img,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                  ).toList(),
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
                                        Text(
                                          "Costo: \$ ${info.costo} mensual",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.5,
                                            fontSize: sizeText,
                                          ),
                                        ),
                                        Text(
                                          "Titular: ${hab.titular}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.5,
                                            fontSize: sizeText,
                                          ),
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
                                          "Teléfono: ${hab.telefono}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.5,
                                            fontSize: sizeText,
                                          ),
                                        ),

                                        Text(
                                          "Dirección: ${hab.direccion}",
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
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserView()))
            },
          ),
          title: Text("Volver"),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection("marker_rent")
                //.where("coords", isNull: false)
                .where("habitaciones", isNotEqualTo: 1)
                  .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for(int i = 0; i < snapshot.data.docs.length; i++){
                  print("=====> ${snapshot.data.docs[i].data()}");
                  //print("=====> ${snapshot.data.docs[i].id}");


                  double lat = snapshot.data.docs[i]['coords'].latitude;
                  double lng = snapshot.data.docs[i]['coords'].longitude;

                  var numHab = snapshot.data.docs[i]['habitaciones'];
                  var latLng = LatLng(lat, lng);

                  String direccion = snapshot.data.docs[i]['direccion'];
                  String telefono = snapshot.data.docs[i]['telefono'];
                  String titular = snapshot.data.docs[i]['titular'];
                  var listTab = snapshot.data.docs[i]['habitaciones'];

                  List<infoHabitacion> listaInfo = [];
                  for(int i=0; i<listTab.length; i++){
                    print(listTab[i]);
                    String servicios = listTab[i]['servicios'];
                    String costo = listTab[i]['costo'];
                    String detalles = listTab[i]['detalles'];

                    listaInfo.add(infoHabitacion(servicios, costo, detalles));
                  }

                  Habitacion habitacion = Habitacion(direccion, telefono, titular, listaInfo);

                  //initMarker(latLng, snapshot.data.docs[i].id, numHab);
                  initMarker(latLng, snapshot.data.docs[i].id, habitacion);

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
