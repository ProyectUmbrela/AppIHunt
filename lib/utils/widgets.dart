import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

MaterialButton longButtons(String title, Function fun,
    {Color color: const Color(0xff01A0C7), Color textColor: Colors.white}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    minWidth: 120,
    child: SizedBox(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12)
      ),
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
    )
  );
}

label(String title) => Text(title);

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Color.fromRGBO(50, 62, 72, 1.0)),
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}


