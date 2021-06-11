// Paquetes para consumir api
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api{

  String _url = 'https://appiuserstest.herokuapp.com/ihunt';
  String _register = '/register';
  Map<String, String> _headers = {"Content-type": "application/json"};

  Future<dynamic> registerPost(data) async{
    var response = await http.post(this._url+_register, body: data, headers: this._headers);

    return response;
  }
}