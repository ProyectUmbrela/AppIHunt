import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ihunt/providers/api.dart';
//import 'package:ihunt/vistas/landlordView.dart';
//import 'package:ihunt/vistas/userView.dart';

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

  /*
  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],*/
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: Text(
        'Ingresar',
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
  */

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
          Text('or'),
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

  void _showDialog(seconds, message) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        Future.delayed(Duration(seconds: seconds), () {
          Navigator.of(context).pop();
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
    new Future.delayed(new Duration(seconds: 4), () {
      setState(() {
        _saving = false;
      });
    });
  }

  Future _sendRequest(emailField, passwordField) async {
    Api _api = Api();
    _submit();
    //print("====================");
    //print(emailField.text);
    //print(passwordField.text);
    //print("====================");
    final body = jsonEncode(
        {'usuario': emailField.text, 'contrasena': passwordField.text});

    var response = await _api.loginPost(body);
    int statusCode = response.statusCode;

    //String responseBody = response.body;
    //print("###########################");
    var resp = json.decode(response.body);

    //print(resp['access_token']);
    if (statusCode == 201) {
      if (resp['tipo'] == 'Propietario') {
        Navigator.pushReplacementNamed(context, '/landlord');
      }
      if (resp['tipo'] == 'Usuario') {
        Navigator.pushReplacementNamed(context, '/user');
      }

      //Navigator.push(
      //  context,
      //  MaterialPageRoute(builder: (context) => Landlord()),
      //);
    } else {
      _showDialog(2, "El usuario o contraseña son incorrectos");
    }
  }

  TextStyle style = TextStyle(fontSize: 18, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    final myControllerEmail = TextEditingController();
    final myControllerPassword = TextEditingController();

    final emailField = TextFormField(
        autofocus: false,
        controller: myControllerEmail,
        //validator: validateEmail,
        decoration: buildInputDecoration("Correo", Icons.email));

    final passwordField = TextFormField(
        autofocus: false,
        controller: myControllerPassword,
        obscureText: true,
        //validator: (value) => value.isEmpty ? "Your name is required" : null,
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

    return Scaffold(
      body: ModalProgressHUD(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  label("Correo o usuario"),
                  SizedBox(height: 15.0),
                  emailField,
                  SizedBox(height: 15.0),
                  //space
                  label("Contraseña"),
                  SizedBox(height: 15.0),
                  passwordField,
                  SizedBox(
                    height: 45.0,
                  ),
                  //space
                  loginbuton,
                  SizedBox(
                    height: 35.0,
                  ),
                  _divider(),
                ],
              ),
            ),
          ),
          inAsyncCall: _saving),
    );
  }
}
