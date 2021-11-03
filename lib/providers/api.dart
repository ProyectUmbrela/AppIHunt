
// Paquetes para consumir api
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  String _url = 'https://appiuserstest.herokuapp.com/ihunt';
  String _register = "/register";
  String _login = '/login';
  String _registerRoom = '/registerRoom';
  String _rooms = '/listarHabitacionesPropietario';
  String _habitacionesRentadas = '/historialInquilino';

  Map<String, String> _headers = {"Content-type": "application/json"};

  Future<dynamic> registerPost(data) async {
    var response = await http.post(Uri.parse(this._url + _register),
        body: data, headers: this._headers);

    return response;
  }

  Future<dynamic> loginPost(data) async {
    var response =
        await http.post(Uri.parse(this._url + _login), body: data, headers: this._headers);

    return response;
  }

  Future<dynamic> RegisterRoomPost(data) async {
    var response = await http.post(Uri.parse(this._url + this._registerRoom),
        body: data, headers: this._headers);

    return response;
  }

  Future<dynamic> GetRooms(data) async {
    print(data.toString());
    var response = await http.post(Uri.parse("https://appiuserstest.herokuapp.com/ihunt/listarHabitacionesPropietario"),
        body: data, headers: this._headers);

    return response;
  }

  Future<dynamic> GetHabitaciones(data) async {
    print(data.toString());
    var response = await http.post(Uri.parse(this._url + this._habitacionesRentadas),
        body: data, headers: this._headers);

    return response;
  }



}
