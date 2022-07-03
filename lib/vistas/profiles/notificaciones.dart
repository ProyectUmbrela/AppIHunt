import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ihunt/providers/provider.dart';

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

  }

  Future getProjectDetails() async {

    try{
      var snapShoot = await FirebaseFirestore.instance
          .collection(GlobalDataUser().notificacionesCollection)
          .doc(_userId)
          .get();
      var fields = snapShoot.data();
      var notificaciones = {};

      print("##########################################################");
      print("##########################################################");
      print(fields);
      //print(fields['1']['fecha'].seconds);
      print("##########################################################");
      print("##########################################################");

      int index = 0;
      for (MapEntry e in fields.entries) {
        var aux = {};
        aux[index.toString()] = {
          'fieldID': e.key,
          'body': e.value['body'],
          'titulo': e.value['title']
        };
        index++;
        notificaciones.addAll(aux);
      }


      return notificaciones;
    }on Exception catch (exception) {

      final snackBar = SnackBar(
        content: const Text('Ocurrio un error!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }catch (error) {
      // aun no recibe notificaciones por lo que no existe el doc en firestore
      return [];
  }


  }

  Widget projectWidget() {

    return FutureBuilder(
      future: getProjectDetails(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          // Esperando la respuesta de la API
          if(snapshot.data == null && snapshot.connectionState == ConnectionState.done){
            return Center(
              //child: Text("Algo salió mal en tu solicitud"),
            );
          }

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
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    dismissible: DismissiblePane(onDismissed: () {
                      var elementId = snapshot.data[index.toString()]['fieldID'];
                      // we can able to perform to some action here
                      FirebaseFirestore.instance
                          .collection(GlobalDataUser().notificacionesCollection)
                          .doc(_userId)
                          .update({
                        elementId : FieldValue.delete(),
                      });

                      setState(() {
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
                        backgroundColor: Colors.grey.shade600,
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
                    height: 85,
                    child: Center(
                      child: Card(
                        color: Colors.grey.shade200,
                        // Con esta propiedad modificamos la forma de nuestro card
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                        // Usamos columna para ordenar un ListTile y una fila con botones
                        child: Column(
                          children: <Widget>[
                            // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
                            ListTile(
                              contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              title: Text(snapshot.data[index.toString()]['titulo'] == null ? '' : snapshot.data[index.toString()]['titulo']),
                              subtitle: Text(snapshot.data[index.toString()]['body'] == null ? '' : snapshot.data[index.toString()]['body']),
                              //leading: Icon(Icons.home),
                            ),
                          ],
                        ),
                      ),
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
