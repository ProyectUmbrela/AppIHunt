import 'package:intl/intl.dart';

String validateEmail(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    _msg = "Correo requerido";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid email address";
  }
  return _msg;
}

String EmailValidating(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    _msg = "Your email is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid email address";
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

  //print(${DateFormat('MM').parse('02')});

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



