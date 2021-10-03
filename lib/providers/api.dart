// Paquetes para consumir api
//import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  String _url = 'https://appiuserstest.herokuapp.com/ihunt';
  String _register = '/register';
  String _login = '/login';
  String _registerRoom = '/registerRoom';

  Map<String, String> _headers = {"Content-type": "application/json"};

  Future<dynamic> registerPost(data) async {
    var response = await http.post(this._url + _register,
        body: data, headers: this._headers);

    return response;
  }

  Future<dynamic> loginPost(data) async {
    var response =
        await http.post(this._url + _login, body: data, headers: this._headers);

    return response;
  }

  Future<dynamic> RegisterRoomPost(data) async {
    var response = await http.post('https://appiuserstest.herokuapp.com/hunt/registerRoom',
        body: data, headers: this._headers);

    return response;
  }

}
