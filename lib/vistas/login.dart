
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ihunt/providers/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihunt/vistas/register.dart';


//IMPORTAR FUNCIONES DE CARPETA utils
import 'package:ihunt/utils/widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _saving = false;

  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();


  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
          Text('o'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget recuperarPass(){
    return InkWell(
      onTap: ()=> {},
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 30.0),
              alignment: Alignment.topRight,
              child: Text('¿Olvidaste tu contraseña?',
                  style: TextStyle(
                      fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Register()));

        },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "¿Aún no tienes una cuenta?",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Registarme',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }



  void _showDialog(seconds, message) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        Future.delayed(Duration(seconds: seconds), () {
          //Navigator.of(context).pop();
        });
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: Text(message),
        );
      },
    );
  }

  void _submit() {
    setState(() {
      _saving = true;
    });

    //print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 2), () {

      setState(() {
        _saving = false;
      });
    });
  }


  onSuccess() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", true);
  }


  Future _sendRequest(emailField, passwordField) async {

    Api _api = Api();
    _submit();
    print("====================");
    print(emailField.text);
    print(passwordField.text);
    print("====================");

    final body = jsonEncode({
          'usuario': emailField.text,
          'contrasena': passwordField.text
        });

    var response = await _api.loginPost(body);
    int statusCode = response.statusCode;

    var resp = json.decode(response.body);


    var sharedPreferences = await SharedPreferences.getInstance();
    if (statusCode == 201) {


      sharedPreferences.setBool("isLogged", true);
      sharedPreferences.setString("nombre", resp['nombre']);
      sharedPreferences.setString("idusuario", resp['idusuario']);
      sharedPreferences.setString("Tipo", resp['Tipo']);

      if (resp['Tipo'] == 'Propietario') {
        //Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, '/landlord');
      }
      if (resp['Tipo'] == 'Usuario') {
        //Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, '/user');
       
      }

    } else {
      _saving = false;
      sharedPreferences.setBool("isLogged", false);
      _showDialog(2, "El usuario o contraseña son incorrectos");
    }
  }


  TextStyle style = TextStyle(fontSize: 18, color: Colors.black);

  @override
  Widget build(BuildContext context) {


    final emailField = TextFormField(
        autofocus: true,
        controller: myControllerEmail,
        decoration: buildInputDecoration("Correo", Icons.email));

    final passwordField = TextFormField(
        autofocus: false,
        controller: myControllerPassword,
        obscureText: true,
        decoration: buildInputDecoration("Contraseña", Icons.remove_red_eye));

    final loginbuton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => _sendRequest(myControllerEmail, myControllerPassword),
        child: Text("Ingresar",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white)),
      ),
    );

    /*
    List<String> fotos = [
      "https://awsrpia.s3.amazonaws.com/habitaciones/199709810_3930934096956302_8955632156523703761_n.jpg",
      "https://awsrpia.s3.amazonaws.com/habitaciones/200093415_107240988265907_2391073375870101507_n.jpg",
      "https://awsrpia.s3.amazonaws.com/habitaciones/201482550_532932834826458_3630072694624410304_n.jpg",
      "https://awsrpia.s3.amazonaws.com/habitaciones/201763526_107240834932589_1701097239284879277_n.jpg",
      "https://awsrpia.s3.amazonaws.com/habitaciones/201822557_532998261486582_8554378459947353905_n.jpg",
      "https://awsrpia.s3.amazonaws.com/habitaciones/202073837_501458407829418_6563349131041000474_n.jpg"
    ];
  
    return Scaffold(
      appBar: AppBar(
        title: Text("Fotos de la habitacion en renta"),
      ),
      body: ListView.builder(
        itemCount: fotos.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Image.network(fotos[index]),
          );
        },
      ),
    );
  */


    //final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ModalProgressHUD(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(60.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 30.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Correo o usuario"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 30.0),
                    child: emailField,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 30.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Contraseña"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 30.0),
                    child: passwordField,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 30.0),
                    child: loginbuton,
                  ),
                  recuperarPass(),
                  _divider(),
                  Padding(
                    padding: const EdgeInsets.all(50.0),

                  ),
                  _createAccountLabel()
                ],
              ),
            ),
          ),
          inAsyncCall: _saving
      ),
    );

  }
}
