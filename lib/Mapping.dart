import 'LoginPage.dart';
import 'HomePage.dart';
import 'Authentication.dart';
import 'package:flutter/material.dart';

//This Mapping page is made so as to check each time when the user comes to app the app checks whether the user has
//previously signed in or not. If yes, then it will direct to the HomePage else to the Login page.

class MappingPage extends StatefulWidget{

  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });

  @override
  State<StatefulWidget> createState() {
    return _MappingPageState();
  }
}
enum AuthStatus{
  notSignedIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage>{

  AuthStatus authStatus = AuthStatus.notSignedIn;


  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId)
    {
      setState(() {
        authStatus = firebaseUserId == null? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });

  }

  void _signedIn(){
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {

    switch(authStatus){

      case AuthStatus.notSignedIn:

        return LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

      case AuthStatus.signedIn:

        return HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );

    }

    return null;
  }

}
