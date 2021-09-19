import 'package:flutter/material.dart';

class Tenants extends StatefulWidget {
  @override
  _TenantsState createState() => _TenantsState();
}

class _TenantsState extends State<Tenants> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de inquilinos de propietario'),
      ),
    );
  }
}
