
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/gestures.dart';

class Ayuda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AyudaPage(),
    );
  }
}

class AyudaPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AyudaPage> {


  double viewFourSize = 14.5;
  double widthGlobal = 340.0;
  double heightGlobal = 82.0;

  // 4
  Widget contactCardView(){
    return Card(
      color: Colors.white70,
      child: Container(
        width: widthGlobal,
        height: heightGlobal,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 30.0,
                  //color: Colors.white70,
                  child: Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Contáctanos",
                        style: TextStyle(fontSize: viewFourSize),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 160.0,
                  //color: Colors.cyan,
                  child: Column(
                    children: [
                      SizedBox(height:10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Puedes enviarnos tus comentarios al",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "correo: ayuda@gmail.com",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "un miembro de nuestro equipo se pondrá",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "en contacto contigo para resolver tus ",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "dudas acerca de nuestro servicio, ",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "quejas o sugerencias",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: heightGlobal,
                  //color: Colors.amber,
                  child: Column(
                    children: [
                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Visita nuestra página web:",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "www.webpage.com",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 75.0,
                  //color: Colors.white12,
                  child: Column(
                    children: [
                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Puedes seguirnos en",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "nuestras redes sociales",
                              style: TextStyle(fontSize: viewFourSize),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 95.0,
                  //color: Colors.indigo,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: heightGlobal,
                  //color: Colors.deepOrange,
                  child: Center(
                    /*child: SelectableLinkify(
                                onOpen: _onOpen,
                                //textScaleFactor: 4,
                                text: "xample@gmail.com",
                              ),
                          ),*/
                    child:RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Términos y condiciones",
                              //style: TextStyle(fontSize: viewFourSize),
                              style: TextStyle(
                                  fontSize: viewFourSize,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap = (){
                                print("******************************* object");
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    //alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Text(
                        "Versión: 3.5.123",
                        style: TextStyle(fontSize: 13.0),

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 3
  Widget inquilinosCardView(){
    return Card(
      color: Colors.white70,
      child: Container(
        width: widthGlobal,
        height: heightGlobal,
        child: Center(
          child: Text(
            "3",
            style: TextStyle(
                color: Colors.white,
                fontSize: 36.0
            ),
          ),
        ),
      ),
    );
  }

  // 2
  Widget habCardView(){
    return Card(
      color: Colors.white70,
      child: Container(
        width: widthGlobal,
        height: heightGlobal,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 40.0,
                  child: Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Los detalles importan",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: widthGlobal,
                    //color: Colors.amber,
                    height: 60.0,
                    child: Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                        child: Text(
                          "Registra las habitaciones que deseas poner en renta, añade una descripcion clara sobre los servicios incluidos, beneficios o negocios cercanos",
                          style: TextStyle(fontSize: viewFourSize),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 30.0,
                  child: Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Fotos claras",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: widthGlobal,
                    //color: Colors.amber,
                    height: 80.0,
                    child: Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                        child: Text(
                          "Añade fotográfias a tus habitaciones, esto ayudará a los demás a identificar y conocer con más detalles tus habitaciones así como las condiciones en las que se encuentra.",
                          style: TextStyle(fontSize: viewFourSize),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 30.0,
                  child: Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 1.0),
                      child: Text(
                        "Mis habitaciones",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 335.0,
                  //color: Colors.cyan,
                  child: Column(
                    children: [
                      //SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: widthGlobal,
                              //color: Colors.amber,
                              height: 40.0,
                              child: Align(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    "Para comenzar con la publicacion de tus habitaciones sigue los siguientes pasos:",
                                    style: TextStyle(fontSize: viewFourSize),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: widthGlobal,
                              //color: Colors.amber,
                              height: 87.0,
                              child: Align(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    "1 Abre la pestaña de habitaciones, llena el formulario mostrado, añade una descripcion corta y detallada de tu habitacion, costo mensual así como los servicios, no olvides añadir fotografias a tu registro. ",
                                    style: TextStyle(fontSize: viewFourSize),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: widthGlobal,
                              //color: Colors.amber,
                              height: 80.0,
                              child: Align(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    "2 Tu registro pasara por un proceso de revision para asegurarnos de que tu postulacion cumple con nuestras reglas, de ser correcto recibiras una notificacion de completado.",
                                    style: TextStyle(fontSize: viewFourSize),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: widthGlobal,
                              //color: Colors.amber,
                              height: 80.0,
                              child: Align(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    "3 Una vez que tu registro este completo, tu habitacion sera mostrada a todo los usuario, comenzaras a recibir notificaciones y a tu primer inquilino",
                                    style: TextStyle(fontSize: viewFourSize),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 1
  Widget rentiCardView(){
    return Card(
      color: Colors.white70,
      child: Container(
        width: widthGlobal,
        height: heightGlobal,//MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Text(
            "1",
            style: TextStyle(
                color: Colors.white,
                fontSize: 36.0
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      //key: UniqueKey(),
      appBar: AppBar(
        title: Text('Ayuda'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        height: MediaQuery.of(context).size.height * 0.9,
        child: ListView(
          scrollDirection : Axis.horizontal,
          children: <Widget>[
            rentiCardView(),
            habCardView(),
            inquilinosCardView(),
            contactCardView(),
          ],
        ),
      ),
    );
  }

  /*
  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }*/

}










