import 'dart:async';

import 'package:chat_translate/screens/home/chat.dart';
import 'package:chat_translate/services/database.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  dynamic searchUsername = '';
  Timer _timer;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        if(index == 0) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              child: TextFormField(
                controller: _controller,
                onChanged: (val) {
                  // ?. is used to check if something is null, if so return null and 
                  // the expression evaluates to what is after the ?? (false)
                  // and if the expression evaluates to null it will not execute the rest
                  // all the ? are used for the first onChanged since the _timer hasn't been init yet. 
                  if(_timer?.isActive ?? false) _timer.cancel();
                  _timer = Timer(Duration(milliseconds: 1000), () async {
                    dynamic result = await DatabaseService().checkUsername(_controller.text);
                    if(result) {
                      setState(() {
                        searchUsername = _controller.text;
                      });
                    } else {
                      setState(() => searchUsername = null);
                    }
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2,),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: () async {
                    FocusScope.of(context).unfocus();
                    dynamic result = await DatabaseService().checkUsername(_controller.text);
                    if(result) {
                      setState(() {
                        searchUsername = _controller.text;
                      });
                    } else {
                      setState(() => searchUsername = null);
                    }
                  }),
                  suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: () {_controller.clear();},),
                ),
              ),
            ),
          );
        }
        else if(searchUsername != '' && searchUsername != null){
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage("assets/blank_profile_pic.png"),
                ),
                title: Text(
                  searchUsername,
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(messages: [], name: searchUsername,)));
                  },
                  icon: Icon(Icons.message, color: Colors.lightBlue,),
                ),
              ),
            ),
          );
        } else if(searchUsername == null) {
          return Column(
            children: <Widget>[
              SizedBox(height: 100.0,),
              Icon(
                Icons.search,
                size: 100.0,
              ),
              Text(
                "User not found",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ]
          );
        }
      },
    );
  }
}

    // return Padding(
    //   padding: const EdgeInsets.all(10.0),
    //   child: Form(
    //     child: TextFormField(
    //       controller: _controller,
    //       decoration: InputDecoration(
    //         fillColor: Colors.white,
    //         filled: true,
    //         enabledBorder: OutlineInputBorder(
    //           borderSide: BorderSide(color: Colors.white, width: 2,),
    //         ),
    //         focusedBorder: OutlineInputBorder(
    //           borderSide: BorderSide(color: Colors.blue, width: 2),
    //         ),
    //         prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {}),
    //         suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: () {_controller.clear();},),
    //       ),
    //     ),
    //   ),
    // );
