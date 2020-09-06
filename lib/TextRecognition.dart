import 'package:flutter/material.dart';

class TextRecognition extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TextRecognitionState();
  }

}

class TextRecognitionState extends State<TextRecognition>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.orange,
       title: Text(
           "Using AI System",
       style: TextStyle(
         color: Colors.black,
         fontWeight: FontWeight.bold,
         fontSize: 20.0
       ),),
      centerTitle: true,
     ),


   );
  }

}