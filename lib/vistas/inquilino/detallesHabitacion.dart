import 'package:flutter/material.dart';


class DetallesHab extends StatefulWidget {

  String name;
  String estado;
  String periodo;
  String idhabitacion;
  String telefono;
  String costoRenta;
  String tiempoRenta;
  String terminosRenta;
  String direccion;
  String servicios;
  String descripcion;
  String fechaPago;

  DetallesHab({
    this.name,
    this.estado,
    this.periodo,
    this.idhabitacion,
    this.telefono,
    this.costoRenta,
    this.tiempoRenta,
    this.terminosRenta,
    this.direccion,
    this.servicios,
    this.descripcion,
    this.fechaPago
  });


  @override
  _DetallesHab createState() => _DetallesHab();
}


class _DetallesHab extends State<DetallesHab> {

  double sizeText = 16;
  var colorCards = Colors.grey[700];

  Widget detallesPropietario() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 1.0, left: 10.0, right: 10.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        color: colorCards,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Text('Titular: ' + widget.name.toString(),
                        style: TextStyle(color: Colors.white, fontSize: sizeText))]
              ),
              Row(
                  children: <Widget>[
                    Text('Tel: ' + widget.telefono.toString(),
                        style: TextStyle(color: Colors.white, fontSize: sizeText))]
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detallesRenta() {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        color: colorCards,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Text("Costo de renta \$ " + widget.costoRenta.toString(),
                      style: TextStyle(color: Colors.white, fontSize: sizeText))]
                ),
                Row(
                    children: <Widget>[
                      Text("Dias de pago: " + widget.fechaPago.toString() + " de cada mes",
                          style: TextStyle(color: Colors.white, fontSize: sizeText))]
                ),
                Row(
                    children: <Widget>[
                      Text('Desde: ' + widget.periodo.toString(),
                          style: TextStyle(color: Colors.white, fontSize: sizeText))]
                ),
                Row(
                    children: <Widget>[
                      Text('No. de Meses: ' + widget.tiempoRenta.toString() + " meses",
                          style: TextStyle(color: Colors.white, fontSize: sizeText))]
                ),
                Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Términos de renta: ' + widget.terminosRenta.toString(),
                          style: TextStyle(color: Colors.white, fontSize: sizeText)),
                      ),
                    ]
                )
              ],
            )
        ),
      ),
    );

  }

  Widget detallesHabitacion() {

    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 10.0, left: 10.0, right: 10.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        color: colorCards,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Expanded(
                          child: Text('Dir: ' + widget.direccion.toString(),
                              style: TextStyle(color: Colors.white, fontSize: sizeText))),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Text('Servicios: ' + widget.servicios.toString(),
                          style: TextStyle(color: Colors.white, fontSize: sizeText))]
                ),
                Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Detalles adicionales: ' + widget.descripcion.toString(),
                            style: TextStyle(color: Colors.white, fontSize: sizeText)),
                      ),
                    ]
                )
              ],
            )
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Resumen de habitación"),
          automaticallyImplyLeading: false,
        ),
      body: Column(
        children: <Widget>[
          detallesPropietario(),
          detallesRenta(),
          detallesHabitacion()
        ],
      ),
    );
  }


}





