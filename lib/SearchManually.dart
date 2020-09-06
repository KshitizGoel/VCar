import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Posts.dart';

class SearchManually extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return SearchManuallyState();
  }

}

class SearchManuallyState extends State<SearchManually>{

  TextEditingController carNumberController = TextEditingController();

  String contactNumberFromDB;

  List <Posts> postsList = [];

  String phoneNumberCalling;

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Details");


    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Search Manually",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black
                ),),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),

      body: Form(
        child: ListView(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),

              child: TextFormField(
                decoration: InputDecoration(

                  labelText: "Car Number",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,

                    fontSize: 20.0
                  ),
                  prefixIcon: Icon(
                    Icons.directions_car,
                    color: Colors.black87,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.black87,width: 5.0),
                  ),

                ),

              textCapitalization: TextCapitalization.characters,
                
                controller: carNumberController,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 15.0 , right:15.0, top:30.0, bottom:25.0),
              child: RaisedButton(
                padding: EdgeInsets.all(10.0),
                elevation: 20.0,
                color: Colors.orange,
                child: Column(
                  children: <Widget>[

                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),

                    Text(
                      "Search",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],

                ),

                onPressed: (){

                  String carNumberInput = carNumberController.text.toString().replaceAll(" ", "");


                  dbRef.orderByChild("carNo").equalTo(carNumberInput).once().then(
                          (DataSnapshot snap){
                            // ignore: non_constant_identifier_names
                            var KEYS = snap.value.keys;
                            var DATA = snap.value;

                            postsList.clear();

                            for(var individualKey in KEYS){

                              Posts posts = Posts(
                              DATA[individualKey]["carNo"],
                              DATA[individualKey]["phoneNo"],
                              DATA[individualKey]["ownerName"],
                              DATA[individualKey]["flatNo"],
                              );
                              postsList.add(posts);
                            }

                            setState((){
                              this.postsList = postsList;
                            });
                          }
                  );
                },
              ),
            ),

            Container(
              child: postsList.length==0? Text(" ") : ListView.builder(
                  shrinkWrap: true,

                  itemCount: postsList.length,

                  itemBuilder:(context,int index){
                    return postsUI(postsList[index].carNo, postsList[index].ownerName, postsList[index].phoneNo, postsList[index].flatNo);
                  }
              ),

            ),

          ],
        ),
      ),

    );
  }

  Widget postsUI ( String carNo, String ownerName, int flatNo,  int phoneNo){
    phoneNumberCalling = phoneNo.toString();

    contactNumberFromDB = phoneNo.toString();

    return ListView(

      shrinkWrap: true,

      children: <Widget>[
        Card(
          elevation: 20.0,

          margin: EdgeInsets.only(left: 25.0 , right:25.0, top:15.0, bottom:15.0),

          child: Container(
            padding: EdgeInsets.all(20.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget> [

                Text(
                  "Name: $ownerName",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),

                  textAlign: TextAlign.center,
                ),


                Padding(

                  padding: EdgeInsets.only(top: 40.0),

                  child: Text(
                    "Flat Number:  ${flatNo.toString()}"  ,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(

                  padding: EdgeInsets.only(top: 40.0),

                  child:Text(
                    "Contact Number:  ${phoneNo.toString()}"  ,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                    ),
                    textAlign: TextAlign.center,


                  ),
                ),



              ],
            ),
          ),


        ),

        Column(

          children: <Widget>[

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

          ],
        )

      ],

  );
  }

  callTheOwner(){
    String phoneNumber = "tel: $contactNumberFromDB";
    launch(phoneNumber);
  }

  textTheOwner(){
    String sms1 = "sms: $contactNumberFromDB";
    launch(sms1);
  }

}
