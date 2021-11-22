import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LoginTest extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginTestState();
  }
  
}



//FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
FirebaseAuth auth = FirebaseAuth.instance;
String correo = "desonses@gmail.com";




Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  String userId = FirebaseAuth.instance.currentUser.uid;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .set({
        'tokens': FieldValue.arrayUnion([token]),
  });

  print("Token has been saved into users collection");

}


Future<void> _signInWithEmailAndPassword() async {

  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: correo,
        password: "SuperSecretPassword!"
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }

  var currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    print("***************USER SIGNED: ${currentUser.uid}");
  }

  String token = await FirebaseMessaging.instance.getToken();

  print("#### TOKEN GENERADO #### $token");

  await saveTokenToDatabase(token);

  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);


}




Future<void> Registration() async {


  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: "SuperSecretPassword!"
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
/*
  var acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');

  var emailAuth = "virus_dfgh@hotmail.com";
  FirebaseAuth.instance.sendSignInLinkToEmail(
      email: emailAuth, actionCodeSettings: acs)
      .catchError((onError) => print('***Error sending email verification $onError'))
      .then((value) => print('Successfully sent email verification'));
*/

}


void main() async {
  Registration();
  _signInWithEmailAndPassword();




}


class LoginTestState extends State<LoginTest>{

  //FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    main();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGGIN TEST'),
      ),

      //body: projectWidget(),
    );
  }
  
}