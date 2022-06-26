import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'custom_dialog.dart';
//import 'package:flutter/material.dart';


class ProjectModel {

  String bodyMessage;
  String titleMessage;


  ProjectModel({
    this.bodyMessage,
    this.titleMessage,
  });
}


class CustomDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 13.0,right: 8.0),
            decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text("Sorry please try \n again tomorrow", style:TextStyle(fontSize: 30.0,color: Colors.white)),
                    )//
                ),
                SizedBox(height: 24.0),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0)),
                    ),
                    child:  Text(
                      "OK",
                      style: TextStyle(color: Colors.blue,fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap:(){
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*void main() {
  runApp(MyApp());
}*/


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  final customMessage = Container(
      //margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 13.0,right: 8.0),
            decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text("Sorry please try \n again tomorrow", style:TextStyle(fontSize: 30.0,color: Colors.white)),
                    )//
                ),
                SizedBox(height: 24.0),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0)),
                    ),
                    child:  Text(
                      "OK",
                      style: TextStyle(color: Colors.blue,fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap:(){
                    //Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: (){
                //Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );


  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            showDialog(context: context, builder: (BuildContext context) => CustomDialog());
            showDialog(context: context, builder: (BuildContext context) => CustomDialog());
          },
          child: Text('show custom dialog'),
        ),
      ),
    );
  }*/
  User _currentUser;
  var _userId;
  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    _currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      _userId = _currentUser.uid;
    });
    print("############################ ${_userId}");
  }

  Future getProjectDetails() async {

    var snapShoot = await FirebaseFirestore.instance
        .collection('notificaciones')
        .doc(_userId)
        .get();
    print(snapShoot.data());
    var fields = snapShoot.data();
    var notificaciones = {};

    for (int i = 0; i < fields.length; i++){
      var aux = {};
      aux[i.toString()] = {'body': fields[i.toString()]['body'].toString(), 'titulo':fields[i.toString()]['titulo'].toString()};
      notificaciones.addAll(aux);
    }

    print("1#################################################");
    print("1#################################################");
    print(notificaciones['0']);
    print(notificaciones['1']);
    print("1#################################################");
    print("1#################################################");

    return notificaciones;
    //return [ProjectModel(bodyMessage: fields['0']['body'].toString(), titleMessage: fields['0']['titulo'].toString())];
  }
  List myList = ["India", "Nepal", "Sri Lanka", "America", "United Kingdom"];

  Widget projectWidget() {

    return FutureBuilder(
      future: getProjectDetails(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          // Esperando la respuesta de la API
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  //Text('Cargando...'),
                ]
            ),
          );
        }
        else if(snapshot.hasData && snapshot.data.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "No tienes nuevas invitaciones, consulta el mapa para encontrar nuevas habitaciones",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        else{
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              print("==========> ${snapshot.data[index.toString()]}");
              var element = snapshot.data[index.toString()];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Slidable(
                  key: const ValueKey(0),
                    endActionPane: ActionPane(
                      dismissible: DismissiblePane(onDismissed: () {
                        // we can able to perform to some action here
                      }),
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          autoClose: true,
                          flex: 1,
                          onPressed: (value) {
                            myList.removeAt(index);
                            setState(() {});
                          },
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Borrar',
                        ),
                        /*SlidableAction(
                          autoClose: true,
                          flex: 1,
                          onPressed: (value) {
                            myList.removeAt(index);
                            setState(() {});
                          },
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),*/
                      ],
                    ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Center(
                        child: Text(
                            element['body'], //myList[index],
                          style: const TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                    ),
                  ),
                )
              );
              /*return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(snapshot.data[index.toString()].body),
                  ),
                  ListTile(
                    title: Text(snapshot.data[index.toString()].titulo),
                  ),
                ],
              );*/
            },
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    //List<String> names = <String>["John","Crea","Mike","Andy"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        automaticallyImplyLeading: false,
      ),
      body: projectWidget(),
    );
  }
}
