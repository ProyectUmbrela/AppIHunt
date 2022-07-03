//import 'package:intl/intl.dart';

String validateEmail(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    _msg = "Correo inválido";
  } else if (!regex.hasMatch(value)) {
    _msg = "Ingresa un correo válido";
  } else{
    _msg = null;
  }
  return _msg;
}

String EmailValidating(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    _msg = "Correo inválido";
  } else if (!regex.hasMatch(value)) {
    _msg = "Ingresa un correo válido";
  }else{
    _msg = 'email-valid';
  }

  return _msg;
}

String validateMobile(String value) {
  String _msg;
  String patttern = r'(^[0-9]*$)';
  RegExp regex = new RegExp(patttern);
  if (value.isEmpty) {
    _msg = "Teléfono requerido";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid phone number address";
  }
  return _msg;
}

String validateSinglePassword(String value) {
  if (value.isEmpty) {
    return "Contraseña inválida";
  } else{
    return null;
  }
  //return "2 Contraseña inválida";
}

String minimumCharacters (String a_password){

  if(a_password.isEmpty){
    return "Contraseña no válida";
  }
  else if(a_password.length < 8){
    return "Mínimo ocho carácteres";
  }
  else{
    return null;
  }

}

String validatePassword(String value, value2) {
  if (value != value2) {
    return "La contraseña no coincide";
  }
  return null;
}

String numberValidator(String value) {
  if(value == null) {
    return null;
  }

  final n = double.tryParse(value);
  if(n == null) {
    return '"$value" No es un número válido';
  }
  else if(n < 0){
    return '1 No es un número válido';
  }
  else if(n == 0){
    return 'No es un número válido';
  }
  else if(n > 1000000){
    return 'No es un número válido';
  }

  return null;
}

String StartDateValidator(DateTime a_date) {

  if(a_date == null) {
    return null;
  }
  // fecha de inicio debera de ser mayor o igual a la fecha actual

  else if(a_date.add(const Duration(days: 1)).isBefore(DateTime.now())){
    return 'Fecha inválida';
  }

}

/*
String EndDateValidator(DateTime a_date) {

  print("********** FROM VALIDATOR FUNCTION: ${a_date}");
  // inicio de formulario, la fecha es null por tal regresamos null como mensaje
  if(a_date == null) {
    return null;
  }
  // fecha de termino debera de ser mayor a la fecha actual
  else if(a_date.isBefore(DateTime.now())){
    return 'Fecha inválida';
  }

}*/


String validateDates(DateTime firstDate, String secondDate){

  if(firstDate == null) {
    return null;
  }
  // fecha de termino debera de ser mayor a la fecha actual
  else if(firstDate.isBefore(DateTime.now())){
    return 'Fecha inválida';
  }
  else if(firstDate.compareTo(DateTime.parse(secondDate)) == -1){
    return 'Fecha inválida';
  }

}



