import 'package:chatflutter/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Service service = Service();

  final auth = FirebaseAuth.instance;
  final storeMessage = FirebaseFirestore.instance;

  TextEditingController msg = TextEditingController();

  getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loginUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                service.signOut(context);
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(loginUser!.email.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              height: 500,
              child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  reverse: true,
                  child: ShowMessage())),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.blue, width: 0.2),
                  )),
                  child: TextField(
                    controller: msg,
                    decoration: InputDecoration(hintText: "Enter message"),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (msg.text.isNotEmpty) {
                    storeMessage.collection("Message").doc().set(
                      {
                        "messages": msg.text,
                        "user": loginUser!.email.toString(),
                        "time": DateTime.now()
                      },
                    );
                    msg.clear();
                  }
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Message")
          .orderBy("time")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            // reverse: true,
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            primary: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              QueryDocumentSnapshot x = snapshot.data!.docs[index];
              return ListTile(
                  title: Column(
                crossAxisAlignment: loginUser!.email == x["user"]
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: loginUser!.email == x['user']
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.amber.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(x["messages"]),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            x["user"],
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          ),
                          // title: Text(x["messages"]),
                          // subtitle: Text(x["user"]),
                        ],
                      )),
                ],
              ));
            });
      },
    );
  }
}
