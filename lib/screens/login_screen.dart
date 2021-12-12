import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_chat/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quick_chat/screens/registration_screen.dart';
import '../button_list.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id="login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  String email="",password="";
  bool showSpinner=false;
  String status="";
  bool notVisible=false;
  final _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  email=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your E-mail'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  password=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Password'),
                obscureText: notVisible^true,
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: notVisible,
                    onChanged: (value) {
                      setState(() {
                        notVisible= value ?? true;
                      });
                    },
                  ),
                  Text(
                    'show password',
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async{
                      setState(() {
                        showSpinner=true;
                      });
                      try{
                        await _auth.sendPasswordResetEmail(
                            email: email);
                        Navigator.pop(context);
                        setState(() {
                          showSpinner=false;
                        });
                        Fluttertoast.showToast(msg: "Recovery Mail has been Sent",gravity: ToastGravity.BOTTOM);
                      }on FirebaseAuthException catch(error){
                        setState(() {
                          showSpinner=false;
                        });
                        Fluttertoast.showToast(msg: error.message ?? "Undefined error",gravity: ToastGravity.BOTTOM);
                      }
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              button_list(
                color: Colors.lightBlueAccent,
                text: 'Log In',
                onPressed: () async{
                  setState(() {
                    showSpinner=true;
                  });
                  try{
                    final user= await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if(user!=null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner=false;
                    });
                  }on FirebaseAuthException catch(error){
                    setState(() {
                      showSpinner=false;
                    });
                    Fluttertoast.showToast(msg: error.message ?? "Undefined error",gravity: ToastGravity.BOTTOM);
                  }
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('New to App?'),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
