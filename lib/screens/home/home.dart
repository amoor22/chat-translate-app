import 'package:chat_translate/screens/authenticate/user.dart';
import 'package:chat_translate/screens/home/chat.dart';
import 'package:chat_translate/screens/home/search.dart';
import 'package:chat_translate/screens/home/settings.dart';
import 'package:chat_translate/services/auth.dart';
import 'package:chat_translate/services/database.dart';
import 'package:chat_translate/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  List<Widget> homeScreens = [Home(), SearchPage(), ChatPage(), SettingsPage()];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Chat-Translate"),
        actions: <Widget>[
          FlatButton.icon(
            label: Text("Log out"),
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: ListView(
              addAutomaticKeepAlives: true,
              children: <Widget>[
                DrawerListItem(text: "Home", icon: Icons.home,pressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _currentIndex = 0;
                  });
                }),
                DrawerListItem(text: "Search", icon: Icons.search,pressed: () {
                  setState(() {
                    Navigator.of(context).pop(context);
                    _currentIndex = 1;
                  });
                }),
                DrawerListItem(text: "Temp Chat", icon: Icons.chat,pressed: () {
                  setState(() {
                    Navigator.of(context).pop(context);
                    _currentIndex = 2;
                  });
                }),
                DrawerListItem(text: "Settings", icon: Icons.settings, pressed: () {
                  setState(() {
                    Navigator.of(context).pop(context);
                    _currentIndex = 3;
                  });
                },)
              ],
            ),
          ),
        ),
      ),
      body: homeScreens[_currentIndex],
    );
  }
}

class Home extends StatefulWidget {
  String username;
  Home({this.username});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    return Container(
      child: StreamBuilder( //streambuilder
        stream: DatabaseService(uid: user.uid).messageCollection.document(user.uid).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Loading();
          }
          // print(snapshot.data[0]);
          try {
            DocumentSnapshot snapshots = snapshot.data;
            List<dynamic> chatTitle = new List();
            List<dynamic> chatLastMessage = new List();
            snapshots.data.forEach((key, value) {
              chatTitle.add(key);
              if(value.length > 0){
                chatLastMessage.add(value[value.length - 1]);
              } else {
                chatLastMessage.add("");
              }
            });
            if(chatTitle.length > 0) {
              return ListView.builder(
                itemCount: chatTitle.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        List<dynamic> messages = snapshots.data[chatTitle[index]];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(messages: messages.reversed.toList(), name: chatTitle[index],)));
                      },
                      title: Text(chatTitle[index]),
                      leading: CircleAvatar(backgroundImage: AssetImage('assets/blank_profile_pic.png'),),
                      subtitle: Text((chatLastMessage[index].length <= 50) ? chatLastMessage[index] : chatLastMessage[index].substring(0, 51 - 5) + "....."),
                    ),
                  );
                },
              );
            } else {
              return Text("dsa");
            }
          } catch(e) {

          }
        },
      ),
    );
  }
}

class DrawerListItem extends StatelessWidget {
  final String text;
  final Function pressed;
  final IconData icon;
  DrawerListItem({ this.text, this.pressed, this.icon });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: pressed,
      ),
      elevation: 10.0,
    );
  }
}

    /* return Container(
      height: 60.0,
      padding: EdgeInsets.all(8),
      child: RaisedButton.icon(
        onPressed: pressed,
        icon: Icon(this.icon),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
        color: Colors.blue,
      ),
    ); */
