import 'package:flutter/material.dart';
import 'package:ihunt/vistas/inquilino/detalles_invitacion.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificacionesInquilino extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationesInquilinoState();
  }
  
}

class NotificationesInquilinoState extends State<NotificacionesInquilino>{

  /*
  Future getProjectDetails() async {
    String idUsuario;
    //String nombre;
    //String tipo_usuario;
    var sharedPreferences = await SharedPreferences.getInstance();

    idUsuario = sharedPreferences.getString("idusuario") ?? "Error";
    //nombre = sharedPreferences.getString("nombre") ?? "Error";
    //tipo_usuario = sharedPreferences.getString("Tipo") ?? "Error";

    var result = [];//await getInvitaciones(idUsuario);
    return result;

  }

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
                  Text('Cargando...'),
                ]
            ),
          );
        }
        else if(snapshot.hasData && snapshot.data.isEmpty) {
          // Informacion obtenida de la API pero esta vacio el response
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "No tienes invitaciones recientes",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        else  {
          // Informacion obtenida y con datos en el response
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              //Habitacion habitacion = snapshot.data[index];
              return Column(
                /*children: <Widget>[
                  habitacionDetalles(habitacion)
                ],*/
              );
            },
          );
        }
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis habitaciones'),
      ),
      body: projectWidget(),
    );
  }
  */
  String _url = 'https://appiuserstest.herokuapp.com/ihunt/registerTenant/.eJyrVspMKS0uTSzKzFeyUspOzCxOzTM3V9IBCmckJmWWJCZn5ucBZQpS80oy8kuLUy2LSxKLwPIFRfkFmaklUK0uiUXZfpnpGSVKtQDzGx35.YdpOZw.a1NCfWNgc1N6Pn0vBOhAY41IuT0';

  void _launchURL() async {
    if (!await launch(_url,
        forceSafariVC: true,
        forceWebView: true)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {

    final todo = ModalRoute.of(context).settings.arguments;

    var message;
    if (todo == "Empty!"){
      message = "No tienes nuevas invitaciones";
    }
    else{
      message = todo;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Invitaciones"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${message}",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              onPressed: _launchURL,
              child: Text('Show Flutter homepage'),
            ),
            RaisedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>DetallesInvitacion()));
              },
              child: Text('Detalles'),
            ),
          ],
        ),
      ),
    );
  }
  
}