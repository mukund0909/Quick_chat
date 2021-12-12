import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_chat/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quick_chat/screens/profile_page.dart';

import '../button_list.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id='registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email="",password="";
  final _auth=FirebaseAuth.instance;
  bool notVisible=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
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
              textAlign: TextAlign.center,
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
              ],
            ),
            button_list(
              color: Colors.blueAccent,
              text: 'Register',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(email,password)));
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Already have an account?'),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  child: Text(
                    "Login",
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
    );
  }
}