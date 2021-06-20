import 'package:chat_translate/services/auth.dart';
import 'package:chat_translate/services/database.dart';
import 'package:chat_translate/shared/constants.dart';
import 'package:chat_translate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService _auth = AuthService();
  String username = '';
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Sign Up"),
        // centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text("Sign In"),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Username"),
                validator: (val) => val.isEmpty ? "Please choose another username" : null,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                onChanged: (val) {
                  setState(() => username = val);
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                validator: (val) => val.isEmpty ? "Please enter a valid E-mail" : null,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (val) => val.length < 6 ? "Please enter a 6+ char password" : null,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                child: Text(
                  "Sign Up"
                ),
                color: Colors.blue[300],
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    bool usernameTaken = await DatabaseService().checkUsername(username);
                    dynamic result;
                    if (!usernameTaken) {
                      result = await _auth.registerWithEmailAndPassword(email, password, username);
                    } else {
                      result = null;
                    }
                    if(result == null) {
                      setState(() {
                        error = "Please check your credentials";
                        loading = false;
                      });
                    } else {
                      DatabaseService(uid: result.uid).insertUsername(username);
                    }
                  }
                },
              ),
              SizedBox(height: 20.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}