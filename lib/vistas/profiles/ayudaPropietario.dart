
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/gestures.dart';

class AyudaPropietario extends StatelessWidget {
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
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 40.0,
                  //color: Colors.white70,
                  child: Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Administra a tus inquilinos",
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
                                    "Una vez que un usuario te a contactado y esta seguro de que desea ocupar alguna de tus habitaiones sigue los siguientes pasos:",
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
                              height: 95.0,
                              child: Align(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    "1 Dirigete a la pestaña de inquilinos donde podrás darlo de alta, selecciona la habitacion a la cual esta asignado, cuando inicia su contrato y el periodo de uso, además podrás indicar fecha límite de pago y detalles adicionales a la contratacion",
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
                              height: 95.0,
                              child: Align(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    "2 Al termino de registro se enviará una notificación a tu futuro inquilino con los términos, costo y detalles de renta, el último paso será solo aceptarla. Tienes un límite de cinco invitaciones al dia para cada una de tus habitaciones",
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
                              height: 95.0,
                              child: Align(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                  child: Text(
                                    "3 Podrás ver el estado de tu invitación, en la pestaña de invitaciones. Una vez aceptada podrás ver a tu nuevo inquilino con un resumen de sus datos, periodo, costo de renta y más.",
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
                          "Añade fotográfias a tus habitaciones, esto ayudará a los demás a identificar y conocer con más detalle tus habitaciones así como las condiciones en las que se encuentra",
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
                                    "1 Abre la pestaña de habitaciones, llena el formulario mostrado, añade una descripcion corta y detallada de tu habitacion, costo mensual así como los servicios, no olvides añadir fotografias a tu registro",
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
                                    "2 Tu registro pasará por un proceso de revision para asegurarnos de que tu solicitud cumple con nuestras reglas, de ser correcto recibirás una notificación de completado",
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
                                    "3 Una vez que tu registro este completo estás listo para recibir a tu primer inquilino, tu habitación será mostrada a todos los usuario, comenzarás a recibir vistas y notificaciones de contacto",
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
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: widthGlobal,
                  height: 40.0,
                  //color: Colors.white70,
                  child: Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "¿Cómo funciona?",
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
                    height: 130.0,
                    child: Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                        child: Text(
                          "Con RentI puedes registrar y publicar las habitaciones que deseas alquilar, administrar a tus inquilinos, revisar fechas de pago, establecer contratos de renta"
                              ", recibe alertas y sugerencias para rentar más rápido tus espacios gestionando de forma fácil",
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
                Expanded(
                  child: Container(
                    width: widthGlobal,
                    //color: Colors.amber,
                    height: 40.0,
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
                    height: 40.0,
                    child: Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                        child: Text(
                          "Cargos y comisiones",
                          style: TextStyle(fontSize: 24.0),
                        ),
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
                    //color: Colors.blue,
                    height: 190.0,
                    child: Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                        child: Text(
                          "RentI realizará un cargo de \$50 adicional al costo de renta de tus habitaciones, una vez que has recibido el pago de cada uno de tus inqulinos se descontará este monto de tu cuenta por lo que requieres de un medio de pago registrado, si no tienes algún inquilino registrado no efectuaremos ningún cargo de esta manera solo pagas cuando la uses, este cargo será realizado por cada uno de tus registros activos y será efectivo durante los meses de renta",
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


}










