
import 'package:flutter/material.dart';
//import 'package:ihunt/vistas/inquilino/userView.dart';
import 'package:url_launcher/url_launcher.dart';

class DetallesInvitacion extends StatefulWidget {
  String contrato;
  String descripcion;
  String detalles;
  String dimension;
  String direccion;
  String enlace_aceptar;
  String enlace_rechazar;
  String fechaEnvio;
  String fechaFin;
  String fechaInicio;
  String fechaPago;
  String idhabitacion;
  String idpropietario;
  String meses;
  String nombre;
  String plazo;
  String precio;
  String servicios;
  String telefono;
  String terminos;

  DetallesInvitacion({
    this.contrato,
    this.descripcion,
    this.detalles,
    this.dimension,
    this.direccion,
    this.enlace_aceptar,
    this.enlace_rechazar,
    this.fechaEnvio,
    this.fechaFin,
    this.fechaInicio,
    this.fechaPago,
    this.idhabitacion,
    this.idpropietario,
    this.meses,
    this.nombre,
    this.plazo,
    this.precio,
    this.servicios,
    this.telefono,
    this.terminos
  });


  @override
  _DetallesInvitacion createState() => _DetallesInvitacion();
}

class _DetallesInvitacion extends State<DetallesInvitacion> {


  void _launchURL(URL) async {

    print("=================> ${URL}");
    try{
      if (!await launch(URL.replaceAll('http', 'https'),
          forceSafariVC: true,
          forceWebView: true)) throw 'Could not launch ${URL}';
    }catch (err){
      print("Error: ${err}");
    }

  }

  showAlertDialogRejected(BuildContext context) {

    Widget rechazarRentaButton = Material(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff01A0C7),
        child: MaterialButton(
            onPressed:() {
              Navigator.of(context).pop();
              _launchURL(widget.enlace_rechazar.toString());

            },
            child: Text(
              "Aceptar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
        ),
    );


    AlertDialog alert = AlertDialog(
      title: Text("Advertencia"),
      content: Text("Si cancelas esta invitación ya no podrás rentar la habitación."),
      actions: [
        rechazarRentaButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogAccepted(BuildContext context) {

    Widget aceptarRentaButton = Material(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        //minWidth: (MediaQuery.of(context).size.width/3),
        onPressed:() {
          Navigator.of(context).pop();
          _launchURL(widget.enlace_aceptar.toString());
        },
        child: Text(
          "Aceptar",
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Colors.white,
            fontSize: 15.0,
          ),
        ),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Advertencia"),
      content: Text("¿Estás seguro de que deseas rentar esta habitación? acepta para indicar que has leído los términos mencionados."),
      actions: [
        aceptarRentaButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double titlesSize = 18.0;
    double textSize = 15.0;


    final rechazarButton = Material(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xFF757575),
        //EF9A9A, E57373, EF5350, B71C1C, C62828, D32F2F, D50000
        child: MaterialButton(
            minWidth: (MediaQuery
                .of(context)
                .size
                .width / 3),
            onPressed: () {
              showAlertDialogRejected(context);
            },
            child: Text(
              "Rechazar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
        ),
    );

    final rentarButton = Material(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xFF01A0C7),
        // C8E6C9, A5D6A7, 81C784,2E7D32, 388E3C, 1B5E20
        child: MaterialButton(
            minWidth: (MediaQuery
                .of(context)
                .size
                .width / 3),
            onPressed: () {
              showAlertDialogAccepted(context);
            },
            child: Text(
              "Rentar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
        ),
    );

    FontWeight fontInfo = FontWeight.w500;
    FontWeight fontTitle = FontWeight.w800;

    return Scaffold(
      appBar: AppBar(
        title: Text("Invitación"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width ,
                        height: MediaQuery.of(context).size.height * 0.79,
                        child: Card(
                          color: Colors.blue[100],
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 100.0),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text('Disponible',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: fontTitle,
                                                    color: Colors.black,
                                                    fontSize: 30)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Titular: ' + widget.nombre.toString(), // NOMBRE
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Tel. contacto: ' + widget.telefono.toString(),  // TELEFONO
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        //Expanded(child: Text(String.fromCharCodes(List.generate(100, (i) => 65)))),
                                        Expanded(
                                          child: Text('Dir: ' + widget.direccion.toString(), // DIRECCION
                                            textAlign: TextAlign.left,style: TextStyle(
                                                  fontWeight: fontInfo,
                                                  color: Colors.black,
                                                  fontSize: textSize)
                                          ),
                                        ),
                                        /*Padding(
                                          padding: EdgeInsets.only(),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Dir: ' + widget.direccion.toString(), // DIRECCION
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),
                                          ),
                                        ),*/
                                      ],
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 0, top: 10),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Detalles de la habitación',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontTitle,
                                                    color: Colors.black,
                                                    fontSize: titlesSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Costo: ' + widget.precio.toString() + ' mensual', // PRECIO
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Servicios: ' + widget.servicios.toString() + ' incluidos', // SERVICIOS
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text('Descripción: ' + widget.descripcion.toString(), // DESCRIPCION
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: fontInfo,
                                                color: Colors.black,
                                                fontSize: textSize)
                                          ),
                                        ),
                                        /*Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Descripción: ' + widget.descripcion.toString(), // DESCRIPCION
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),*/
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Tamaño: ' + widget.dimension.toString() + ' de espacio', // DIMENSION
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text('Detalles de contrato: ' + widget.detalles.toString(), // DETALLES
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: fontInfo,
                                                color: Colors.black,
                                                fontSize: textSize)
                                          ),
                                        ),
                                        /*Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Detalles de contrato: ' + widget.detalles.toString(), // DETALLES
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),*/
                                      ],
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Términos de renta',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontTitle,
                                                    color: Colors.black,
                                                    fontSize: titlesSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),
                                      ],
                                  ),
                                  Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: widget.terminos.toString() == '' ? Text('Términos de contrato: No', //TERMINOS
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: fontInfo,
                                                  color: Colors.black,
                                                  fontSize: textSize)
                                          ): Text('Términos de contrato: ' + widget.terminos.toString(), //TERMINOS
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: fontInfo,
                                                color: Colors.black,
                                                fontSize: textSize)
                                          ),
                                        ),
                                        /*Padding(
                                          padding: EdgeInsets.only(left: 0, top: 10),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Términos de contrato: ' + widget.terminos.toString(), //TERMINOS
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: fontInfo,
                                                    color: Colors.black,
                                                    fontSize: textSize)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        ),*/
                                      ],
                                  ),
                                ],
                              ),
                          ),
                        ),
                      ),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width ,
                          height: MediaQuery.of(context).size.height * 0.09,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left:30, bottom: 5),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: rechazarButton,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left:80, bottom: 5),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: rentarButton,
                                ),
                              ),
                            ],
                          ),
                      ),
                    ],
                ),
              ],
          ),
        ],
      ),
    );
  }
}
