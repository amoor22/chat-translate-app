import 'package:chat_translate/screens/authenticate/authenticate.dart';
import 'package:chat_translate/screens/authenticate/sign_in.dart';
import 'package:chat_translate/screens/authenticate/sign_up.dart';
import 'package:chat_translate/screens/authenticate/user.dart';
import 'package:chat_translate/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return AuthenticateScrn();
    } else {
      return HomePage();
    }
  }
}