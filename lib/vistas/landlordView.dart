import 'package:flutter/material.dart';
import 'package:ihunt/vistas/register.dart';
import 'package:ihunt/vistas/rooms.dart';
import 'package:ihunt/vistas/tenants.dart';

class Landlord extends StatefulWidget {
  @override
  _LandlordState createState() => _LandlordState();
}

class _LandlordState extends State<Landlord>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.airline_seat_individual_suite)),
                Tab(icon: Icon(Icons.accessibility)),
              ],
            ),
            title: Text('UserName'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.home),
              rooms(),
              Tenants(),
            ],
          ),
        ),
      ),
    );
  }
}
