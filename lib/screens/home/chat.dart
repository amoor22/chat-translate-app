import 'dart:convert';
import 'package:chat_translate/screens/authenticate/user.dart';
import 'package:chat_translate/services/database.dart';
import 'package:chat_translate/shared/constants.dart';
import 'package:chat_translate/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
// try extra space 
class ChatPage extends StatefulWidget {
  List<dynamic> messages;
  String name;
  ChatPage({this.messages, this.name});
  @override
  _ChatPageState createState() => _ChatPageState();
}
ThemeData chatTheme = ThemeData(
  primaryColor: Colors.lightBlue[300],
  secondaryHeaderColor: Colors.white,
);
class _ChatPageState extends State<ChatPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String message = '';
  int maxChar = 300;
  String remaining;


  @override
  void initState() {
    super.initState();
    remaining = maxChar.toString();
  }
  @override
  Widget build(BuildContext context) {
    dynamic user = Provider.of<User>(context);
    // print(Encrypt(text: "test").decrypt());
    // RsaEncrypt().generateKeys(2, 7);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: DatabaseService(uid: user.uid).messageCollection.document(user.uid).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return Loading();
                }
                if(snapshot.data[widget.name] != null) {
                  widget.messages = snapshot.data[widget.name];
                  widget.messages = widget.messages.reversed.toList();
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: widget.messages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        // Message(isRight: widget.messages[index][widget.messages[index].length - 1] == ' '? false : true, message: widget.messages[index],),
                        Message2(message: widget.messages[index], isRight: widget.messages[index][widget.messages[index].length - 1] == " " ? false : true,),
                        SizedBox(height: 10.0),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(maxChar),
                      ],
                      validator: (val) => val.isEmpty || val.trim() == "" ? "Please write a message" : null,
                      controller: _controller,
                      onChanged: (val)  {
                        message = val;
                        setState(() {
                          remaining = "${maxChar - message.length}";
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter a message",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500], width: borderWidth),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue, width: borderWidth),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      FlatButton.icon(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          // print(await DatabaseService().findUid(widget.name));
                          if(_formKey.currentState.validate()) {
                            message = message.trim();
                            setState(() => remaining = maxChar.toString());
                            DatabaseService().sendMessage(user.uid, widget.name, message);
                            _controller.clear();
                          }
                          // print(await DatabaseService().findUsername(user.uid));
                        },
                        // send(from: uid, to: targetUid)
                        label: Text("Send"),
                      ),
                      Text(remaining),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}

class Message extends StatelessWidget {
  final bool isRight;
  final String message;
  Message({this.isRight, this.message});
  @override
  Widget build(BuildContext context) {
    if (isRight) {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Expanded(
            flex: 8,
            child: Card(
              color: chatTheme.primaryColor,
              child: ListTile(
                onLongPress: () {},
                title: Text(message, style: TextStyle(fontSize: 17.0),),
                trailing: Icon(Icons.person),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Card(
              color: chatTheme.secondaryHeaderColor,
              child: ListTile(
                onLongPress: () {},
                title: Text(message, style: TextStyle(fontSize: 17.0),),
                leading: Icon(Icons.person),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      );

    }
  }
}
class Message2 extends StatefulWidget {
  String message;
  String messageC;
  bool isRight;
  Message2({this.message, @required this.isRight}){
    this.messageC = message;
  }

  @override
  _Message2State createState() => _Message2State();
}

class _Message2State extends State<Message2> {
  bool isTranslated = false;
  Map<String, dynamic> settings;
  String toLanguage;
  Color _iconColor = Colors.grey;

  Future<String> translate(String text, String to) async {
    if(to == null) {
      return "";
    }
    Response response = await get("https://api.mymemory.translated.net/get?q=${text}&langpair=en|${to}");
    Map map = jsonDecode(response.body);
    // print(map);
    // return "Translated: $text";
    String t = map["responseData"]["translatedText"];
    return "Translated: $t";
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   User user = Provider.of<User>(context, listen: false);
    //   settings = await DatabaseService(uid: user.uid).initSettings();
    //   setState(() => toLanguage = settings["language"]);
    // });
    
    Future.delayed(Duration.zero, () async{
      User user = Provider.of<User>(context, listen: false);
      settings = await DatabaseService(uid: user.uid).initSettings();
      setState(() => toLanguage = settings["language"]);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isRight) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(width: MediaQuery.of(context).size.width / 4),
          Flexible(
            child: Container(
              // alignment: Alignment.centerRight,
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      size: 25.0,
                    ),
                    onPressed: () {},
                  ),
                ],
              ), 
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              // make a settings menu in the home widget where u can choose language
              // translate button.
              padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10)
              ),
              // alignment: Alignment.centerRight,
              // width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.translate,
                      size: 25.0,
                      color: _iconColor,
                    ),
                    onPressed: () async {
                      String finalText = (!isTranslated) ? await translate(widget.message, toLanguage) : widget.messageC;
                      setState(() {
                        widget.message = finalText;
                        _iconColor = (!isTranslated) ? Colors.green : Colors.grey;
                        isTranslated = !isTranslated;                
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ), 
            ),
          ),
          Container(width: MediaQuery.of(context).size.width / 4),
        ],
      );
    }
  }
}