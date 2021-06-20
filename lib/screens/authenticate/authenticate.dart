import 'package:chat_translate/screens/authenticate/sign_in.dart';
import 'package:chat_translate/screens/authenticate/sign_up.dart';
import 'package:flutter/material.dart';

class AuthenticateScrn extends StatefulWidget {
  @override
  _AuthenticateScrnState createState() => _AuthenticateScrnState();
}

class _AuthenticateScrnState extends State<AuthenticateScrn> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}