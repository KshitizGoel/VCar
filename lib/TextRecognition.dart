import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vkar/DialogBox.dart';

import 'Posts.dart';

class TextRecognition extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return TextRecognitionState();
  }

}

class TextRecognitionState extends State<TextRecognition>{

  File sampleImage;
  final formKey = GlobalKey<FormState> ();
  String url;
  final picker = ImagePicker();

  String phoneNumberOfTheCarOwner= " ";
  String b= " ";


  Future getImage() async {
    final tempImage = await picker.getImage(source: ImageSource.camera);

    setState(() {
      sampleImage =File(tempImage.path);
    });
    readText();
  }

  var textRecognizedByAI = " ";

  Future readText( ) async{

    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(sampleImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizeText.processImage(ourImage);

    for(TextBlock block in visionText.blocks){
      for(TextLine line in block.lines){
        for(TextElement word in line.elements){

          setState(() {
            textRecognizedByAI = textRecognizedByAI  + word.text + " ";
          });
        }
        textRecognizedByAI = textRecognizedByAI + "\n";
      }
    }
    recognizeText.close();

    getDetailsFromDB();

  }

  List <Posts> postsList = [];
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Details");
  DialogBox dialogBox = DialogBox();

  Future getDetailsFromDB() async {

    String carNumberInput = textRecognizedByAI.toString().replaceAll(" ", "");

    postsList.clear();
    dbRef.orderByChild("carNo").equalTo(carNumberInput.trim()).once().then(
            (DataSnapshot snap) {

          // ignore: non_constant_identifier_names
          var DATA = snap.value;

          postsList.clear();
          if (DATA != null) {

            var KEYS = snap.value.keys;


            for (var individualKey in KEYS) {
              Posts posts = Posts(
                DATA[individualKey]["carNo"],
                DATA[individualKey]["flatNo"],
                DATA[individualKey]["ownerName"],
                DATA[individualKey]["phoneNo"],
              );
              postsList.add(posts);
            }

            setState(() {
              this.postsList = postsList;
            });

          }
          else{
            //Alert Dialog
            postsList.clear();

            dialogBox.information(context, "No Information :(","This car $carNumberInput does not belong to any resident of Veer Apartment! ");
          }
        });
    // Container(
    //   child: postsList.length==0?
    //
    //   Text("")
    //
    //       : ListView.builder(
    //       shrinkWrap: true,
    //
    //       itemCount: postsList.length,
    //
    //       itemBuilder:(context,int index){
    //         return Text(
    //             "${postsList[0].carNo}" "${postsList[1].phoneNo.toString()}" "${postsList[2].flatNo.toString()}" "${postsList[3].carNo}",
    //
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20.0
    //           ),
    //
    //         ) ;
    //       }
    //   ),
    //
    // );

  }



  @override
  Widget build(BuildContext context) {
   return Scaffold(

     appBar: AppBar(
       backgroundColor: Colors.orange,
       centerTitle: true,
       title: Text(
           "Use our AI system",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.black
              ),  ) ,
     ),

     body: Center(

       child: sampleImage == null? Text( "Please upload a photo to continue!")
           :

       enableUpload()

     ),

     floatingActionButton: FloatingActionButton(
       onPressed: getImage,
       tooltip: "AddImage",
       child: Icon(Icons.add_a_photo),
     ),

   );
  }
  Widget enableUpload() {
    return Form(
        key: formKey,
        child: ListView(

            padding: EdgeInsets.all(20.0),

            children: <Widget>[

              Image.file(sampleImage, height: 330.0, width: 660.0),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "The text recognized is:  ${textRecognizedByAI.toString()}",
                ),
              ),

            ListView.builder(
                shrinkWrap: true,
                itemCount: postsList.length,
                itemBuilder: (BuildContext context, int ind){

                  phoneNumberOfTheCarOwner = postsList[ind].phoneNo.toString();

                  return Card(

                    elevation: 20.0,

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.all(20.0),

                          child:  Text(
                              "Name : ${postsList[ind].ownerName} ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                            ),
                          ),


                        ),

                        Padding(
                          padding: EdgeInsets.all(20.0),

                          child:  Text(
                                 "Flat No : ${postsList[ind].flatNo.toString()} ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                            ),
                          ),


                        ),

                        Padding(
                          padding: EdgeInsets.all(20.0),

                          child:  Text(
                            "PhoneNo : ${postsList[ind].phoneNo.toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                            ),
                          ),


                        ),




                      ],

                    ),

                  );
                }),

              Padding(
                padding: EdgeInsets.only(top: 20.0 ),

                child: ButtonTheme(

                  minWidth: 300.0,
                  height: 65.0,

                  child:  RaisedButton(
                    elevation: 10.0,
                    color: Colors.black,

                    child: Column(
                      children: <Widget>[

                        Icon(
                            Icons.call,
                            color: Colors.white
                        ),

                        Text(
                          "CALL",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white
                          ),
                        )

                      ],
                    ),

                    onPressed: (){
                      callTheOwner();
                    },

                  ),

                ),),

              Padding(
                  padding: EdgeInsets.only(top: 40.0 ),

                  child: ButtonTheme(

                    minWidth: 300.0,
                    height: 65.0,

                    child:  RaisedButton(
                      elevation: 10.0,
                      color: Colors.black,

                      child: Column(
                        children: <Widget>[

                          Icon(
                              Icons.message,
                              color: Colors.white
                          ),

                          Text(
                            "SMS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white
                            ),
                          )

                        ],
                      ),

                      onPressed: (){
                        textTheOwner();
                      },

                    ),

                  )

              )

            ]
        )
    );
  }


  callTheOwner(){
    String phoneNumber = "tel: ${phoneNumberOfTheCarOwner.toString()}  ";
    launch(phoneNumber);
  }

  textTheOwner(){
    String sms1 = "sms: ${phoneNumberOfTheCarOwner.toString()}";
    launch(sms1);
  }

  }



