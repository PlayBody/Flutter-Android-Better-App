import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'bottomnav.dart';
import 'chat.dart';
import 'firebase_meesage_list.dart';
import 'myappbar.dart';
import '../common/globals.dart' as globals;

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatList createState() => _ChatList();
}

class _ChatList extends State<ChatList> {
  bool isAttendance = false;
  DatabaseReference _messagesRef =
      FirebaseDatabase().reference().child('list').child('u' + globals.userId);

  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    globals.appTitle = 'メッセージ';
    globals.bottomNavSelect = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: MyAppBar(),
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Column(
            children: [
              profileList(),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNav(),
    ));
  }

  profileList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: _messagesRef,
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = MessageList.fromJson(json);
          return MessageWidget(message);
        },
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final model;

  MessageWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    model.senderName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              Text(
                model.message,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        leading: Image(
          image: AssetImage('images/person01.png'),
          width: 60,
          fit: BoxFit.contain,
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Chat(userId: model.id, userName: model.senderName);
          }));
        },
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)))),
    );
  }
}
