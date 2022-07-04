import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ihunt/vistas/inquilino/AdmobHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ihunt/vistas/profiles/notificaciones.dart';
import 'rooms.dart';
import 'tenants.dart';
import 'invitation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihunt/vistas/profiles/user_profile.dart';
import 'package:ihunt/providers/provider.dart';
import 'package:ihunt/vistas/profiles/ayudaPropietario.dart';

class Landlord extends StatefulWidget {
  @override
  _LandlordState createState() => _LandlordState();
}


class _LandlordState extends State<Landlord> {
  User _currentUser;
  String _nombre;
  int _currentIndex = 0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String AmessageTitle = "Empty!";
  var tokenBy = '';



  @override
  void initState() {
    AdmobHelper.initialization();

    super.initState();
    setData();
    firebaseCloudMessaging_Listeners();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (!mounted) {
        return;
      }
      setState(() {
          print("A #############################################");
          print("A #############################################");
          print("${event.notification.title}");
          print("A #############################################");
          print("A #############################################");
          AmessageTitle = event.notification.title;
          //notificationAlert = "New Notification Alert";
          if (event.notification != null) {
            print('Message also contained a notification: ${event.notification.body}');

          }
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      if (!mounted) {
        return;
      }
      setState(() {
          print("1 #############################################");
          print("1 #############################################");
          print("${event.notification.title}");
          print("1 #############################################");
          print("1 #############################################");
          AmessageTitle = event.notification.title;
          //notificationAlert = "Application opened from Notification";
      });
    });
  }



  void setData() async {
    _currentUser = FirebaseAuth.instance.currentUser;

    var snapShoot = await FirebaseFirestore.instance
        .collection(GlobalDataLandlord().userCollection)
        .doc(_currentUser.uid)
        .get();

    setState(() {
      _nombre = snapShoot['nombre'];
    });
  }

  Future<void> saveTokenToDatabase(String token) async {
    // upsert, insert if not exists or add anew one if already exists
    var _current = await _currentUser.uid;

    await FirebaseFirestore.instance.collection(GlobalDataLandlord().userCollection).doc(_current).set(
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
    //setState(() => _saving = false);

    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  /*Future _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    return settings.authorizationStatus;
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
                    ),
                ),
            ),
            /*
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
        return Rooms(); // second page
      case 2:
        return Tenants(); // third page
      case 3:
        return Invitations(); // fourth page
    }
    return Center(child: Text("No disponible"),);
  }

  Widget menuOptions(){
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '$_nombre',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Cuenta',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Notificaciones',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MisNotificaciones()),
                );
            },
          ),
          ListTile(
            title: Text(
              'Ayuda',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Update the state of the app.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AyudaPropietario()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Salir',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );

  }

  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
          child:_getView(_currentIndex)),
      appBar: AppBar(
          title: Center(
              child: Text(
                'RentI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              )
          )
      ),
      endDrawer: menuOptions(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.primary,
        selectedItemColor: Colors.white,
        onTap: (value) {
          // Si el index es distinto a la vista actual
          if(_currentIndex != value){
            setState(() => _currentIndex = value);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airline_seat_individual_suite),
            label: 'Habitaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Inquilinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Invitaciones',
          ),
        ],
      ),
    );
  }
}


