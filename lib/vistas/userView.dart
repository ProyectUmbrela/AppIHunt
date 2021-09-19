import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';



class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> with SingleTickerProviderStateMixin {


  //var SharedPreferences = sharedPreferences;
  // "idusuario": "fredy",
  // "nombre": "fredydemo"

  String id_usuario;
  String nombre;

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


  Widget getRow(String stringval, double textSize , double opacity){
      return Opacity(
        opacity: opacity,
        child:  Container(
          margin: const EdgeInsets.only(top: 20.0),
          child : Text(stringval ?? 'default_value',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ) ;
    }
  void _logout() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", false);

    Navigator.of(context).pushReplacementNamed('/login');
  }


  

  @override
  Widget build(BuildContext context) {

    final lugaresbutton = Material(
      
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      
      child: MaterialButton(
        
        minWidth: (MediaQuery.of(context).size.width/3.3),
        //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //onPressed: () => _{},
        
        onPressed: ()=>{},
        child: Text("Mis lugares",
            textAlign: TextAlign.center
            
            //style: style.copyWith(color: Colors.white)),
      )
      ),
    );


    final buscarbutton = Material(
      
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      
      child: MaterialButton(
        
        minWidth: (MediaQuery.of(context).size.width/3.3),
        //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //onPressed: () => _{},
        
        onPressed: ()=>{},
        child: Text("Buscar",
            textAlign: TextAlign.center
            
            //style: style.copyWith(color: Colors.white)),
      )
      ),
    );

    final mensagesbutton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      
      child: MaterialButton(
        
        minWidth: (MediaQuery.of(context).size.width/3.3),
        //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //onPressed: () => _{},
        onPressed: ()=>{},
        child: Text("Mensajes",
            textAlign: TextAlign.center
            //style: style.copyWith(color: Colors.white)),
      )
      ),
    );



    return Scaffold(
      appBar: AppBar(
        title: Text('Hola $nombre'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Text("Log out"),
              new IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: _logout,
              )
            ],
          )
        ],
      ),
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
          //mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
             Container(
               child: Icon(Icons.person ,
                 color: Colors.white,
                 size: 50.0,
               ),
            ),
            //getRow(nombre, 30.0, 5.0),
            getRow(id_usuario, 15.0, 0.6),
            //SizedBox(height: 90.0),
            //buscarbutton,
            //SizedBox(height: 0.0,),
            //buscarbutton
          ],
          
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left:30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: lugaresbutton,//Icon(Icons.camera_alt),),
            ),
          ),
          Padding(padding: EdgeInsets.only(left:30, right: 0),
            child:Align(
            alignment: Alignment.bottomCenter,
            child: buscarbutton,
          )),
          Padding(padding: EdgeInsets.only(left:30, right: 0, bottom: 0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: mensagesbutton,
          )),
        ],
      )
    );
  }

  
}
