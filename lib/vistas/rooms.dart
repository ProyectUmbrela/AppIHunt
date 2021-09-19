import 'package:flutter/material.dart';

class rooms extends StatefulWidget {
  @override
  _roomsState createState() => _roomsState();
}

class _roomsState extends State<rooms> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de habitaciones de propietario'),
      ),
    );
  }
}
