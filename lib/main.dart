import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vkar/Authentication.dart';
import 'Mapping.dart';


  void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
  }

  class MyApp extends StatefulWidget{
    @override
    State<StatefulWidget> createState() {
      return MyAppState() ;
    }

  }

  class MyAppState extends State<MyApp> {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: "Blog App",

        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),

        home:MappingPage(auth: Auth()),

      );

    }
  }