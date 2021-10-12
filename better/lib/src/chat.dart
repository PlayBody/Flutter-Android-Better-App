import 'package:better/src/usermodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'bottomnav.dart';
import 'firebase_meesage_list.dart';
import 'firebase_message.dart';
import 'myappbar.dart';
import '../common/globals.dart' as globals;

class Chat extends StatefulWidget {
  final String userId;
  final String userName;
  const Chat({required this.userId, required this.userName, Key? key})
      : super(key: key);

  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> {
  var btnStyle1 = ElevatedButton.styleFrom(
      primary: Colors.blue[300], onPrimary: Colors.white);

  late Future<List> loadData;

  //var messageDao;

  bool isAttendance = false;
  List<UserModel> userList = [];
  var _messageController = TextEditingController();
  DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('message');
  DatabaseReference _listRef =
      FirebaseDatabase.instance.reference().child('list');

  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    globals.appTitle = 'チャット';
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
        child: Scaffold(
            appBar: MyAppBar(isLeading: true),
            body: OrientationBuilder(builder: (context, orientation) {
              return Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    _getMessageList(_messagesRef),
                    // Expanded(child: Container()),
                    Container(
                      child: Row(
                        children: [
                          // Container(
                          //   width: 50,
                          //   padding: EdgeInsets.only(right: 8),
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //         padding: EdgeInsets.all(0),
                          //         primary: Colors.green,
                          //         onPrimary: Colors.white),
                          //     child: Icon(Icons.add),
                          //     onPressed: () {},
                          //   ),
                          // ),
                          Flexible(
                              child: TextFormField(
                            //keyboardType: TextInputType.,
                            controller: _messageController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 15, right: 15),
                              filled: true,
                              fillColor: Colors.white,
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          )),
                          Container(
                            padding: EdgeInsets.only(left: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white),
                              child: Icon(Icons.send),
                              onPressed: () {
                                _sendMessage();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   child: Row(
                    //     children: [
                    //       Container(width: 40),
                    //       ElevatedButton(
                    //           onPressed: () {},
                    //           child: Icon(Icons.attach_file),
                    //           style: btnStyle1),
                    //       Container(width: 8),
                    //       ElevatedButton(
                    //           onPressed: () {},
                    //           child: Icon(Icons.gif),
                    //           style: btnStyle1),
                    //       Container(width: 8),
                    //       ElevatedButton(
                    //           onPressed: () {},
                    //           child: Icon(Icons.smart_button),
                    //           style: btnStyle1)
                    //     ],
                    //   ),
                    // ),
                    // EmojiPicker(
                    //   rows: 3,
                    //   columns: 7,
                    //   buttonMode: ButtonMode.MATERIAL,
                    //   recommendKeywords: ["racing", "horse"],
                    //   numRecommended: 10,
                    //   onEmojiSelected: (emoji, category) {
                    //     print(emoji);
                    //   },
                    // )
                  ],
                ),
              );
            })));
  }

  // emojiContainer() {
  //   return EmojiPicker(
  //     rows: 3,
  //     columns: 7,
  //     buttonMode: ButtonMode.MATERIAL,
  //     recommendKeywords: ["racing", "horse"],
  //     numRecommended: 10,
  //     onEmojiSelected: (emoji, category) {
  //       print(emoji);
  //     },
  //   );
  // }

  void _sendMessage() {
    final message = Message("", _messageController.text, '', '', globals.userId,
        DateTime.now().millisecondsSinceEpoch.toString());

    _messagesRef
        .child(widget.userId + '_' + globals.userId)
        .push()
        .set(message.toJson());

    _messagesRef
        .child(globals.userId + '_' + widget.userId)
        .push()
        .set(message.toJson());

    _listRef.child('u' + globals.userId).child('u' + widget.userId).set(
        MessageList(
                widget.userId,
                'false',
                _messageController.text,
                widget.userId,
                widget.userName,
                '',
                DateTime.now().microsecondsSinceEpoch.toString())
            .toJson());
    _listRef.child('u' + widget.userId).child('u' + globals.userId).set(
        MessageList(
                globals.userId,
                'false',
                _messageController.text,
                globals.userId,
                globals.userName,
                '',
                DateTime.now().microsecondsSinceEpoch.toString())
            .toJson());

    _messageController.clear();
    setState(() {});
    // }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Widget _getMessageList(_messagesRef) {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: _messagesRef.child(globals.userId + '_' + widget.userId),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(
              message.message,
              DateTime.fromMillisecondsSinceEpoch(int.parse(message.time),
                  isUtc: false));
        },
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String message;
  final DateTime date;

  MessageWidget(this.message, this.date);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 150, top: 5, right: 1, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[350]!,
                        blurRadius: 2.0,
                        offset: Offset(0, 1.0))
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.blue[200]),
              child: Text(message),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    DateFormat('yyyy-MM-dd, kk:mma').format(date).toString(),
                    style: TextStyle(color: Colors.grey),
                  )),
            ),
          ],
        ));
  }
}
