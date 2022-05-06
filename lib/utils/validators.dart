String validateEmail(String value) {
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
    _msg = "Your phone number is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid phone number address";
  }
  return _msg;
}

String validatePassword(String value, value2) {
  if (value != value2) {
    return "Las contraseñas no coinciden";
  }
  return null;
}

String numberValidator(String value) {
  if(value == null) {
    return null;
  }
  final n = double.tryParse(value);
  if(n == null) {
    return '"$value" is not a valid number';
  }
  return null;
}
