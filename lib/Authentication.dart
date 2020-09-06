import 'dart:async';
import 'dart:core';
import "package:firebase_auth/firebase_auth.dart";

abstract class AuthImplementation{
  Future<String> signIn(String email, String password);
  Future <String> getCurrentUser();
}

class Auth implements AuthImplementation{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    User user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;

    return user.uid;
  }

  Future <String> getCurrentUser() async{
    User user = await _firebaseAuth.currentUser;
    return user.uid;
  }

}