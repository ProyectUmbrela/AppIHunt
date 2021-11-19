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

  Widget detallesPropietario() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Text(widget.name.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18))]
              ),
              Row(
                  children: <Widget>[
                    Text(widget.telefono.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 16))]
            )
          ],
        ),)
      ),


    );
  }

  Widget detallesRenta() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Text("Costo de renta \$ " + widget.costoRenta.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18))]
                ),
                Row(
                    children: <Widget>[
                      Text("Dias de pago: " + widget.fechaPago.toString() + " de cada mes",
                          style: TextStyle(color: Colors.white, fontSize: 18))]
                ),
                Row(
                    children: <Widget>[
                      Text(widget.periodo.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18))]
                ),
                Row(
                    children: <Widget>[
                      Text(widget.tiempoRenta.toString() + " meses",
                          style: TextStyle(color: Colors.white, fontSize: 18))]
                ),
                Row(
                    children: <Widget>[
                      Text(widget.terminosRenta.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18))]
                )
              ],
            )
        ),
      ),
    );

  }

  Widget detallesHabitacion() {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Text(widget.direccion.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18))]
                ),
                Row(
                    children: <Widget>[
                      Text(widget.servicios.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18))]
                ),
                Row(
                    children: <Widget>[
                      Text(widget.descripcion.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18))]
                )
              ],
            )
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    //var todo = ModalRoute.of(context).settings.arguments;
    //Habitacion detalles = todo as Habitacion;
    print("**************>>>>> ${widget.name.toString()}");
    return Scaffold(
        appBar: AppBar(
            title: Text("Resumen de habitacion")
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





