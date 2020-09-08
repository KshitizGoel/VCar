import 'package:flutter/material.dart';
import 'package:vkar/Authentication.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SearchManually.dart';
import 'TextRecognition.dart';

class HomePage extends StatefulWidget{

  HomePage({
    this.auth, this.onSignedOut,
});

  final AuthImplementation auth;
  final VoidCallback onSignedOut;


  @override
  State<StatefulWidget> createState() {
   return HomePageState();
  }

}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
              fontSize: 25.0
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,

      ),

      body: ListView(
        
        padding: EdgeInsets.all(15.0),
        
        children: <Widget>[



          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: ( context){
                    return SearchManually();
                  })
              );
            },

           child: Card(
              elevation: 25.0,

              margin: EdgeInsets.only(top:7.0, bottom: 15.0, left:10.0 , right:10.0),

              child: Container(
                padding: EdgeInsets.all(10.0),

                child: Column(
                  children: <Widget>[

                    getImage(),

                    Padding(
                      padding: EdgeInsets.only(top:10.0),
                    child: Text(
                      "Enter car number manually",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                    )
                  ],
                ),

              ),

            ),

          ),


          GestureDetector(
            onTap: (){

              Navigator.push(context,
                  MaterialPageRoute(builder: (context){
                    return TextRecognition();
                  })
              );

            },

            child:   Card(
              elevation: 25.0,

              margin: EdgeInsets.only(top:15.0, bottom: 15.0, left:10.0 , right:10.0),

              child: Container(
                padding: EdgeInsets.all(10.0),

                child: Column(
                  children: <Widget>[

                    getImageAsset(),

                    Padding(
                      padding: EdgeInsets.only(top:10.0),

                      child:    Text(
                        "Use our AI system",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )

                  ],
                ),

              ),

            ),

          ),

          GestureDetector(
            onTap: (){
              sendSMS();
            },

            child:  Card(
            elevation: 25.0,

            margin: EdgeInsets.only(top:15.0, bottom: 15.0, left:10.0 , right:10.0),

                child: Container(
                padding: EdgeInsets.all(10.0),

                child: Column(
                children: <Widget>[

                    Icon(
                    Icons.directions_car,
                    color: Colors.black,
                    ),

                    Text(
                    "Add a new car",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                    ),
                textAlign: TextAlign.center,
                ),
                ],
                ),

                ),

            )
          )



                    ],
                  ),
                );
              }
      sendSMS(){
    String sms1 = "sms: ${9958770713}";
    launch(sms1);
      }
            }

class getImage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage("image/car.png");
    Image image = Image(image: assetImage);

    return Container(
      child: image,
    );
  }
}

class getImageAsset extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage("image/machine.jpg");
    Image image = Image(image: assetImage);

    return Container(
      child: image,
    );
  }
}

