import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FireAuth {

  /*
  // For registering a new user
  static Future<User> registerUsingEmailPassword({
    String usuario,
    String tipo,
    String name,
    String email,
    String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
            'correo': usuario,
            'nombre': name,
            'tipo': tipo
          });


    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }*/



  // For signing in an user (have already registered)
  static Future<List> signInUsingEmailPassword({
    String email,
    String password,
  }) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    var user;
    var message;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      message = 'ok';

    } on FirebaseAuthException catch (e) {
      print("*********************************************** ${e.code}");
      if (e.code == 'user-not-fund') {
        user = null;
        message = e.code;
        print('No se encontró un usuario con el correo.');

      } else if (e.code == 'wrong-password') {
        user = null;
        message = e.code;
        print('Contraseña incorrecta.');

      } else if (e.code == 'user-disabled') {
        user = null;
        message = e.code;
        print('Cuenta desactivada.');
      }
    }

    return [user, message];

  }

  static Future<User> refreshUser(User user) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    var refreshedUser = auth.currentUser;
    return refreshedUser;
  }

}