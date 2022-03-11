import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:ihunt/vistas/inquilino/AdmobHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'rooms.dart';
import 'tenants.dart';
import 'invitation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Landlord extends StatefulWidget {
  @override
  _LandlordState createState() => _LandlordState();
}

class _LandlordState extends State<Landlord>
    with SingleTickerProviderStateMixin {

  // VARIABLES DE SESION
  String id_usuario;
  String nombre;
  int _currentIndex = 0;

  @override
  void initState(){
    setData();
  }

  void setData() async{
    var sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      nombre = sharedPreferences.getString("nombre") ?? "Error";
      id_usuario = sharedPreferences.getString("idusuario") ?? "Error";
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget widgetHome() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(0.5),
        padding: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0, 1],
                colors: [Colors.blue[100], Colors.blue[200]],
                tileMode: TileMode.repeated),
            borderRadius: BorderRadius.circular(10.0)),
        alignment: FractionalOffset.center,
        child: Column(
          children: <Widget>[
            Align(
                alignment: FractionalOffset.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    //child: projectWidgetAd(),
                    child: Container(
                        child: AdWidget(
                          ad: AdmobHelper.getBannerAd()..load(),
                          key: UniqueKey(),),
                        height: AdmobHelper.getBannerAd().size.height.toDouble(),
                        width: AdmobHelper.getBannerAd().size.width.toDouble()
                    )
                )),
          ],
        ),
      ),
    );
  }

  Widget _getView(int index) {
    switch (index) {
      case 0:
        return widgetHome(); //first page
      case 1:
        return Rooms(); // second page
      case 2:
        return Tenants(); // third page
      case 3:
        return Invitations(); // fourth page
    }

    return Center(child: Text("There is no page builder for this index."),);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: _getView(_currentIndex),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            // add icon, by default "3 dot" icon
              icon: Icon(Icons.menu),
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Mi cuenta"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Salir"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  print("My account menu is selected.");
                }else if(value == 1){
                  _logout();
                  print("Settings menu is selected.");
                }
              }
          ),
        ],
        title: Text(
          'Hola ${nombre}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        //backgroundColor: colorScheme.primary,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.primary,
        selectedItemColor: Colors.amber,//colorScheme.onSurface,
        //unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        //selectedLabelStyle: textTheme.caption,
        //unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          // Si el index es distinto a la vista actual
          if(_currentIndex != value){
            setState(() => _currentIndex = value);
          }
        },
        items: [
          BottomNavigationBarItem(
            title: Text(
              'Principal',
              style: TextStyle(
                color: Colors.white,),),
            icon: Icon(Icons.home,
              color:Colors.white,),),
          BottomNavigationBarItem(
            title: Text(
              'Hbitaciones',
              style: TextStyle(
                color: Colors.white,),),
            icon: Icon(Icons.airline_seat_individual_suite,
              color:Colors.white,),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Inquilinos',
              style: TextStyle(
                color: Colors.white,),),
            icon: Icon(Icons.person,
              color:Colors.white,),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Invitaciones',
              style: TextStyle(
                color: Colors.white,),),
            icon: Icon(Icons.library_books,
              color:Colors.white,),
          ),
        ],
      ),
    );
  }

}
