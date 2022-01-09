import 'package:flutter/material.dart';
import 'package:ihunt/vistas/inquilino/notificationes_inquilino.dart';
import 'package:ihunt/vistas/inquilino/userView.dart';
import 'package:url_launcher/url_launcher.dart';


class DetallesInvitacion extends StatefulWidget {
  const DetallesInvitacion({Key key}) : super(key: key);

  @override
  _DetallesInvitacionState createState() => _DetallesInvitacionState();
}

class _DetallesInvitacionState extends State<DetallesInvitacion> {

  String _url = 'https://appiuserstest.herokuapp.com/ihunt/registerTenant/.eJyrVspMKS0uTSzKzFeyUspOzCxOzTM3V9IBCmckJmWWJCZn5ucBZQpS80oy8kuLUy2LSxKLwPIFRfkFmaklUK0uiUXZfpnpGSVKtQDzGx35.YdqFTQ.pzsfMQIYYVeoBRp5pVyUPEnyC00';

  void _launchURL() async {
    if (!await launch(_url,
        forceSafariVC: true,
        forceWebView: true)) throw 'Could not launch $_url';
  }


  showAlertDialog(BuildContext context) {


    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {},
    );
    Widget launchButton = TextButton(
      child: Text(
        "Rentar",
        style: TextStyle(
          fontSize: 19.0,
        ),
      ),
      onPressed:  () {
        Navigator.of(context).pop();
        _launchURL();
        /*Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>NotificacionesInquilino()));*/
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("¿Estás seguro de que deseas rentar esta habitación? acepta para indicar que has leído los términos mencionados."),
      actions: [
        //cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {



    final rechazarButton = Material(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xFFEEF5350), //EF9A9A, E57373, EF5350, B71C1C, C62828, D32F2F, D50000
        child: MaterialButton(
            minWidth: (MediaQuery.of(context).size.width/3),
            onPressed: ()=>{},
            child: Text(
              "Rechazar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            )
        )
    );

    final rentarButton = Material(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xFF1B5E20), // C8E6C9, A5D6A7, 81C784,2E7D32, 388E3C, 1B5E20
        child: MaterialButton(
            minWidth: (MediaQuery.of(context).size.width/3),

            onPressed: (){
              showAlertDialog(context);
            },
            child: Text(
              "Rentar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            )
        )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Invitación"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Container(
                        width: 410.0,
                        height: 540.0,
                        child: Card(
                          color: Colors.grey[400],
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width/4)),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Disponible',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black,
                                                    fontSize: 38)
                                            ),//Icon(Icons.camera_alt),),
                                          ),
                                        )
                                      ]
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Container(
                          width: 410.0,
                          height: 60.0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left:30, bottom: 5),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: rechazarButton,//Icon(Icons.camera_alt),),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left:80, bottom: 5),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: rentarButton,//Icon(Icons.camera_alt),),
                                ),
                              ),
                            ],
                          )
                      )
                    ]
                )
              ]
          )
        ],
      ),
    );
  }

}
