import 'package:chat_translate/screens/authenticate/user.dart';
import 'package:chat_translate/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SSettingsPageState extends State<SettingsPage> {
  Widget titleText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.blue, fontSize: 20.0),
    );
  }
  Widget spacer(double height) {
    return SizedBox(height: height,);
  }
  double topBarRadius = 15.0;
  Color _startingColor = Colors.orange;
  String _currentLang;
  Map<String, dynamic> settings;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => _startingColor = Colors.blue));
  }
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    // settings = DatabaseService(uid: user.uid).initSettings().then((val) {
    //   _currentLang = val["language"];
    //   return val;
    // });
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircleAvatar(
                radius: 75.0,
                backgroundImage: AssetImage("assets/blank_profile_pic.png"),
              ),
            ),
            decoration: BoxDecoration(
              color: _startingColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(topBarRadius), bottomRight: Radius.circular(topBarRadius)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer(10),
                titleText("Language"),
                Divider(thickness: 2),
                Card(
                  child: ListTile(
                    title: Text(
                      "Translation Language"
                    ),
                    trailing: StreamBuilder(
                      stream: DatabaseService(uid: user.uid).infoCollection.document(user.uid).snapshots(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) {
                          return Text("data");
                        }
                        settings = snapshot.data["settings"];
                        _currentLang = settings["language"];
                        return DropdownButton(
                          hint: Text("Choose a language"),
                          value: _currentLang,
                          onChanged: (val) {
                            setState(() => _currentLang = val);
                          },
                          items: <String>["en", "ar", "fr", "it"].map<DropdownMenuItem<String>>((val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],  
      ),
    );
  }
}

class _SettingsPageState extends State<SettingsPage> {
  Widget titleText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.blue, fontSize: 20.0),
    );
  }
  Widget spacer(double height) {
    return SizedBox(height: height,);
  }
  double topBarRadius = 15.0;
  Color _startingColor = Colors.orange;
  String _currentLang;
  Map<String, dynamic> settings;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => _startingColor = Colors.blue));
  }
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height / 3,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircleAvatar(
                    radius: 75.0,
                    backgroundImage: AssetImage("assets/blank_profile_pic.png"),
                  ),
                ),
                decoration: BoxDecoration(
                  color: _startingColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(topBarRadius), bottomRight: Radius.circular(topBarRadius)),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spacer(10),
                      titleText("Language"),
                      Divider(thickness: 2),
                      Card(
                        child: ListTile(
                          title: Text(
                            "Translation Language"
                          ),
                          trailing: FutureBuilder(
                            future: DatabaseService(uid: user.uid).initSettings(),
                            builder: (context, snapshot) {
                              if(!snapshot.hasData) {
                                return Text("Loading");
                              }
                              settings = snapshot.data;
                              _currentLang = settings["language"];
                              return DropdownButton(
                                hint: Text("Choose a language"),
                                value: _currentLang,
                                onChanged: (val) async {
                                  Map<String, dynamic> settingsC = settings;
                                  settingsC["language"] = val;
                                  settings = await DatabaseService(uid: user.uid).setSettings(settingsC);
                                  setState(() => _currentLang = val);
                                },
                                items: <String>["en", "ar", "fr", "it"].map<DropdownMenuItem<String>>((val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          // trailing: StreamBuilder(
                          //   stream: DatabaseService(uid: user.uid).infoCollection.document(user.uid).snapshots(),
                          //   builder: (context, snapshot) {
                          //     if(!snapshot.hasData) {
                          //       return Text("Loading");
                          //     }
                          //     settings = snapshot.data["settings"];
                          //     _currentLang = settings["language"];
                          //     return DropdownButton(
                          //       hint: Text("Choose a language"),
                          //       value: _currentLang,
                          //       onChanged: (val) async {
                          //         Map<String, dynamic> settingsC = settings;
                          //         settingsC["language"] = val;
                          //         settings = await DatabaseService(uid: user.uid).setSettings(settingsC);
                          //         setState(() => _currentLang = val);
                          //       },
                          //       items: <String>["en", "ar", "fr", "it"].map<DropdownMenuItem<String>>((val) {
                          //         return DropdownMenuItem(
                          //           value: val,
                          //           child: Text(val),
                          //         );
                          //       }).toList(),
                          //     );
                          //   }
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class Sliver extends StatefulWidget {
  @override
  _SliverState createState() => _SliverState();
}

class _SliverState extends State<Sliver> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Settings"),
            background: Image.network(
              "https://scx1.b-cdn.net/csz/news/800/2019/2-nature.jpg",
              fit: BoxFit.fitWidth
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            List.generate(10, (index) {
              return Card(
                child: ListTile(
                  title: Text(
                    index.toString(),
                    style: TextStyle(fontSize: (index % 2 == 0) ? 50 : 20),
                  ),
                ),
              );
            }),
          ),
        ),
      ],      
    );
  }
}