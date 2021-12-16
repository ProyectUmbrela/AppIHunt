
// Paquetes para consumir api
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ihunt/vistas/propietario/registerTenants.dart';

class Api {
  String _url = 'https://appiuserstest.herokuapp.com/ihunt';
  //String _url = 'https://prdapp.herokuapp.com/ihunt';

  String _register = "/register";
  String _login = '/login';
  String _habitacionesRentadas = '/historialInquilino';

  // urls correspondientes a propietario
  String _registerRoom = '/registerRoom';
  String _deleteRoom = '/eliminarHabitacion';
  String _rooms = '/listarHabitacionesPropietario';

  String _registerTenant = '/registroInquilino';
  String _tenants = '/listarInquilinosPropietario';
  String _deleteTenant = '/eliminarInquilino';

  String _invitations = '/listarInvitacionesPropietario';

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

  Future<dynamic> GetHabitaciones(data) async {
    print(data.toString());
    var response = await http.post(Uri.parse(this._url + this._habitacionesRentadas),
        body: data, headers: this._headers);

    return response;
  }

  /*#####  api de propietario #####*/
  Future<dynamic> RegisterRoomPost(data) async {
    var response = await http.post(Uri.parse(this._url + this._registerRoom),
        body: data, headers: this._headers);

    return response;
  }
  Future<dynamic> DeleteRoomPost(data) async {
    var response = await http.post(Uri.parse(this._url + this._deleteRoom),
        body: data, headers: this._headers);
    return response;
  }
  Future<dynamic> GetRooms(data) async {
    var response = await http.post(Uri.parse(this._url + this._rooms),
        body: data, headers: this._headers);
    return response;
  }

  Future<dynamic> RegisterTenantPost(data) async {
    var response = await http.post(Uri.parse(this._url + this._registerTenant),
        body: data, headers: this._headers);
    return response;
  }
  Future<dynamic> DeleteTenantPost(data) async {
    var response = await http.post(Uri.parse(this._url + this._deleteTenant),
        body: data, headers: this._headers);
    return response;
  }
  Future<dynamic> GetTenants(data) async {
    var response = await http.post(Uri.parse(this._url + this._tenants),
        body: data, headers: this._headers);
    return response;
  }

  Future<dynamic> GetInvitations(data) async {
    print(data.toString());
    var response = await http.post(Uri.parse(this._url + this._invitations),
        body: data, headers: this._headers);
    return response;
  }


}
