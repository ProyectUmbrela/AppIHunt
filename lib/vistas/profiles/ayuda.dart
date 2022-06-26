
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


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

  final List<int> numbers = [1, 2, 3, 5, 8];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //key: UniqueKey(),
      appBar: AppBar(
        title: Text('Ayuda'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        height: MediaQuery.of(context).size.height * 0.9,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: numbers.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Card(
                  color: Colors.blue,
                  child: Container(
                    child: Center(child: Text(numbers[index].toString(), style: TextStyle(color: Colors.white, fontSize: 36.0),)),
              ),
            ),
          );
        }),
      ),
    );
  }

}










