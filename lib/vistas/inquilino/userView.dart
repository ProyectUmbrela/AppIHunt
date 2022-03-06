import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ihunt/vistas/inquilino/googleMaps.dart';
import 'package:ihunt/vistas/inquilino/misLugares.dart';
import 'package:ihunt/vistas/inquilino/notificationesInquilino.dart';

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ihunt/vistas/inquilino/AdmobHelper.dart';

// AdMob
import 'package:google_mobile_ads/google_mobile_ads.dart';

class UserView extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserView> {
  User _currentUser;
  String _idUsuario;
  String _nombre;
  int _currentIndex = 0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String messageTitle = "Empty!";
  var tokenBy = '';

  @override
  void initState() {
    AdmobHelper.initialization();
    super.initState();
    setData();

    firebaseCloudMessaging_Listeners();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      setState(() {
        messageTitle = event.notification.title;
        //notificationAlert = "New Notification Alert";
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      setState(() {
        messageTitle = event.notification.title;
        //notificationAlert = "Application opened from Notification";
      });
    });
  }

  void setData() async {
    _currentUser = FirebaseAuth.instance.currentUser;

    var snapShoot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    setState(() {
      _nombre = snapShoot['nombre'];
      _idUsuario = snapShoot['usuario'];
    });
  }

  Future<void> saveTokenToDatabase(String token) async {
    // upsert, insert if not exists or add anew one if already exists
    var _current = await _currentUser.uid;

    await FirebaseFirestore.instance.collection('users').doc(_current).set(
        {'updatedOn': FieldValue.serverTimestamp(), 'token': token},
        SetOptions(merge: true));
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) async {
      await saveTokenToDatabase(token);
      tokenBy = token;
      _firebaseMessaging.onTokenRefresh.listen(saveTokenToDatabase);
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  /*
  Widget projectWidgetAd() {

    return FutureBuilder(
      future: AdmobHelper.getBannerAd().load(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 90,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: snapshot.data,
          );
        } else {
          return Container(
              child: AdWidget(
                ad: snapshot.data,
                key: UniqueKey(),
              ),
              height: AdmobHelper
                  .getBannerAd()
                  .size
                  .height
                  .toDouble(),
              width: AdmobHelper
                  .getBannerAd()
                  .size
                  .width
                  .toDouble());
        }
      },
    );
  }*/

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
                )), /*
             Container(
               child: Icon(Icons.person ,
                 color: Colors.white,
                 size: 50.0,
               ),
            ),
            getRow(id_usuario, 15.0, 0.6), ##################################### icono de usuario y notificaciones
            Text(
              messageTitle,
              style: Theme.of(context).textTheme.headline4,
            ),*/
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
        return Lugares(); // second page
      case 2:
        return MyMaps(); // third page
      case 3:
        return NotificacionesInquilino(); // fourth page
    }

    return Center(child: Text("There is no page builder for this index."),);
  }


  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: _getView(_currentIndex),
      appBar: AppBar(
        actions: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Salir',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              new IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: _logout,
              )
            ],
          )
        ],
        title: Text(
          'Hola ${_nombre}',
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
              'Lugares',
              style: TextStyle(
                color: Colors.white,),),
            icon: Icon(Icons.location_on,
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

/*
  ThemeData _buildShrineTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: _shrineColorScheme,
      textTheme: _buildShrineTextTheme(base.textTheme),
    );
  }*/
/*
  TextTheme _buildShrineTextTheme(TextTheme base) {
    return base
        .copyWith(
      caption: base.caption.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: defaultLetterSpacing,
      ),
      button: base.button.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: defaultLetterSpacing,
      ),
    )
        .apply(
      fontFamily: 'Rubik',
      displayColor: shrineBrown900,
      bodyColor: shrineBrown900,
    );
  }*/

/*
  const ColorScheme _shrineColorScheme = ColorScheme(
    primary: shrinePink100,
    primaryVariant: shrineBrown900,
    secondary: shrinePink50,
    secondaryVariant: shrineBrown900,
    surface: shrineSurfaceWhite,
    background: shrineBackgroundWhite,
    error: shrineErrorRed,
    onPrimary: shrineBrown900,
    onSecondary: shrineBrown900,
    onSurface: shrineBrown900,
    onBackground: shrineBrown900,
    onError: shrineSurfaceWhite,
    brightness: Brightness.light,
  );*/

/*
  const Color shrinePink50 = Color(0xFFFEEAE6);
  const Color shrinePink100 = Color(0xFFFEDBD0);
  const Color shrinePink300 = Color(0xFFFBB8AC);
  const Color shrinePink400 = Color(0xFFEAA4A4);
  const Color shrineBrown900 = Color(0xFF442B2D);
  const Color shrineBrown600 = Color(0xFF7D4F52);
  const Color shrineErrorRed = Color(0xFFC5032B);
  const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
  const Color shrineBackgroundWhite = Colors.white;
  const defaultLetterSpacing = 0.03;
  */

/*
  Widget customAppBar(){

    return Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.airline_seat_individual_suite)),
            Tab(icon: Icon(Icons.search_sharp)),
            Tab(icon: Icon(Icons.notifications))
          ],
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Text("Salir"),
              new IconButton(
                icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white),
                onPressed: _logout,
              )
            ],
          )
        ],
        title: Text('Hola ${_nombre}'),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          widgetHome(),
          Lugares(),
          MyMaps(),
          NotificacionesInquilino()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: bottomAppBar(),//customAppBar(),
      ),
    );
  }

}
 */
