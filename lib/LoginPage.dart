import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'DialogBox.dart';


class LoginPage extends StatefulWidget{

  LoginPage({
    this.auth,
    this.onSignedIn,
  }
      );

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
   return LoginPageState();
  }

}

enum FormType{
  login
}

class LoginPageState extends State<LoginPage>{

  DialogBox dialogBox = DialogBox();

  final formKey = GlobalKey <FormState> ();
  FormType _formType = FormType.login;
  String _email = " ";
  String _password = " ";


  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void validateAndSubmit() async{

    if(validateAndSave()){
      try{

        if(_formType== FormType.login){
          String userId = await widget.auth.signIn(_email,_password);
          print("Login user ID: $userId ");
        }
        widget.onSignedIn();
      }catch(e){
        dialogBox.information(context, "Error", e.toString());
        print("Exception ${e.toString()}");
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "VeeCar - An AI Powered Car Parking App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )

        ),

      ),

        body: Container(

          margin: EdgeInsets.all(15.0),

          child: Form(

            key: formKey,

            child: ListView(
              padding: EdgeInsets.all(10.0),
              children:  createInput() + createButton(),

            ),
          ),
        )
    );
  }

  List <Widget> createInput(){ // Created a List of Widgets so that all widgets can be placed under this list..." Noice"
    return [
      SizedBox(height: 10.0),
      getImageAsset(),

      SizedBox(height: 20.0),
      TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_box),
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold
          ),
          labelText: "Enter the Email",

        ),
        textCapitalization: TextCapitalization.none,

        validator: (value){
          return value.isEmpty? "Email is required" : null;
        },
        onSaved: (value){
          return _email = value;
        },
      ) ,

      SizedBox(height: 20.0),
      TextFormField(

        keyboardType: TextInputType.number,

        decoration: InputDecoration(
            labelText: "Enter the Password",
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold
            ),
            prefixIcon: Icon(Icons.lock)
        ),
        obscureText: true,
        validator: (value){
          return value.isEmpty? "Password is required" : null;
        },
        onSaved: (value){
          return _password = value;
        },
      ),
    ];
  }

  List<Widget> createButton() {
    return [
      Padding(
        padding: EdgeInsets.only(left: 15.0 , right:15.0, top:30.0, bottom:25.0),
        child: RaisedButton(
          padding: EdgeInsets.all(10.0),
          elevation: 20.0,
          color: Colors.orange,
          child: Column(
            children: <Widget>[

              Icon(
                Icons.fast_forward,
                color: Colors.black,
              ),

              Text(
                "Login",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],

          ),


          onPressed: (){
            validateAndSubmit();
          },
        ),
      ),

      Padding(

        padding: EdgeInsets.all(10.0),

     child: Text(
        "Enter the Login Details provided by our team.",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      )

    ];
  }

}

  class getImageAsset extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage("image/veer.png");
    Image image = Image(image: assetImage);

    return Container(
      child: image,
    );
  }
}
