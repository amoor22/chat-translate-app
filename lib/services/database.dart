import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  final String username;
  DatabaseService({this.uid, this.username});
  // Collection reference
  final CollectionReference messageCollection = Firestore.instance.collection('messageCollection');
  final CollectionReference infoCollection = Firestore.instance.collection("infoCollection");

  Future checkUsername(String username) async {
    QuerySnapshot snapshot = await infoCollection.getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents;
    for (int i = 0; i < documents.length; i++) {
      if (documents[i].data["username"] == username) {
        return true;
      }
    }
    return false;
  }

  Future insertUsername(String username) {
    return infoCollection.document(uid).setData({"username": username});
  }

  Future createDocument() async {
    return await messageCollection.document(uid).setData({});
  }

  Future findUid(String username) async {
    try {
      QuerySnapshot snapshot = await infoCollection.getDocuments();
      List<DocumentSnapshot> documents = snapshot.documents;
      for(int i = 0; i < documents.length; i++) {
        if(documents[i].data["username"] == username) {
          return documents[i].documentID;
        }
      }
      return null;
    } catch(e) {

    }
  }

  Future initSettings() async {
    DocumentReference reference = infoCollection.document(uid);
    Map<String, dynamic> prevSettings;
    await reference.get().then((document) {
      if(document?.data["settings"] != null) {
        prevSettings = document.data["settings"];
      } else {
        reference.updateData({"settings": {"language": "en"}});
        prevSettings = {"language": "en"};
      }
    });
    return prevSettings;
  }

  Future setSettings(Map<String, dynamic> map) async {
    DocumentReference reference = infoCollection.document(uid);
    await reference.updateData({"settings": map});
    return map;
  }

  Future sendMessage(String fromUid, String toUsername, String message) async {
    DocumentReference fromReference = messageCollection.document(fromUid);
    List<dynamic> prevMesg = await fromReference.get().then((document) => document[toUsername]);
    if(prevMesg == null) {
      fromReference.setData({toUsername: [message]});
    } else {
      prevMesg.add(message);
      await fromReference.updateData({toUsername: prevMesg});
    }
    DocumentReference toReference = messageCollection.document(await findUid(toUsername));
    dynamic fromUsername = await findUsername(fromUid);
    List<dynamic> prevMesg2 = await toReference.get().then((document) => document[fromUsername]);
    if(prevMesg2 == null) {
      toReference.setData({fromUsername : ["$message "]});
    } else {
      prevMesg2.add("$message ");
      await toReference.updateData({fromUsername : prevMesg2});
    }
  }

  Future findUsername(String uid) async {
    QuerySnapshot snapshot = await infoCollection.getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents;
    for(int i = 0; i < documents.length; i++) {
      if(documents[i].documentID == uid) {
        return documents[i].data["username"];
      }
    }
    return null;
  }

}
// every user has a document in the database and in it all of his sent / recieved messages