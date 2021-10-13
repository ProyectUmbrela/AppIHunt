import 'package:flutter/material.dart';

class Landlord extends StatefulWidget {
  @override
  _LandlordState createState() => _LandlordState();
}

class _LandlordState extends State<Landlord>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de propietario'),
      ),
    );
  }
}
