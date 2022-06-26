import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class MisNotificaciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageNotificaciones(),
    );
  }
}

class HomePageNotificaciones extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePageNotificaciones> {

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
    var fields = snapShoot.data();
    var notificaciones = {};

    //print(fields);
    int index = 0;
    for (MapEntry e in fields.entries) {
      var aux = {};
      aux[index.toString()] = {'fieldID' : e.key, 'body' : e.value['body'], 'titulo' : e.value['titulo']};
      index++;
      notificaciones.addAll(aux);
    }
    
    return notificaciones;
  }

  /*
  Future removeNotificacion(String index){
    var collection = FirebaseFirestore.instance.collection('notificaciones');
    collection
        .doc(_userId)
        .update({
          index : FieldValue.delete(),
        });

    print("######################## ELEMENTO ELIMINADO ${index} ##########################");

  }*/

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
                  "No tienes nuevas notificaciones",
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

              print("A *************************************************************");
              //print("A ==========> ${index}");
              print(snapshot.data);
              //print("A ==========> ${snapshot.data[index.toString()]}");
              print("A *************************************************************");

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    dismissible: DismissiblePane(onDismissed: () {
                      var elementId = snapshot.data[index.toString()]['fieldID'];
                      // we can able to perform to some action here
                      FirebaseFirestore.instance
                          .collection('notificaciones')
                          .doc(_userId)
                          .update({
                        elementId : FieldValue.delete(),
                      });

                      setState(() {
                        print("DELETE ELEMENT WITH ID: ${elementId} ******************");
                        print("DELETE ELEMENT WITH INDEX: ${index} ******************");
                        snapshot.data.removeWhere((key, value) => key == index.toString());
                      });


                    }),
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        autoClose: true,
                        flex: 1,
                        /*onPressed: (value) {
                          //myList.removeAt(index);
                          //removeNotificacion(index.toString());
                          //setState(() {});
                        },*/
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Borrar',
                        borderRadius: BorderRadius.circular(10),
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
                    height: 80,
                    child: Center(
                      child: Card(
                        // Con esta propiedad modificamos la forma de nuestro card
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                        // Usamos columna para ordenar un ListTile y una fila con botones
                        child: Column(
                          children: <Widget>[
                            // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
                            ListTile(
                              contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              title: Text(snapshot.data[index.toString()]['titulo']),//Text('Titulo'),
                              subtitle: Text(snapshot.data[index.toString()]['body']),//Text('Este es el subtitulo del card. Aqui podemos colocar descripción de este card.'),
                              //leading: Icon(Icons.home),
                            ),
                          ],
                        ),
                      ),
                      /*child: Text(
                          element['body'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15
                          ),
                        ),*/
                    ),
                  ),
                ),
              );
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
      key: UniqueKey(),
      appBar: AppBar(
        title: Text('Notificaciones'),
        automaticallyImplyLeading: false,
      ),
      body: projectWidget(),
    );
  }
}
