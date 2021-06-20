import 'package:chat_translate/screens/authenticate/user.dart';
import 'package:chat_translate/screens/home/wrapper.dart';
import 'package:chat_translate/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        // theme: ThemeData(
        // ),
      ),
    );
  }
}

