import 'package:firebase_database/firebase_database.dart';

class MessageList {
  final String id;
  final String isBlock;
  final String message;
  final String senderId;
  final String senderName;
  final String senderPhoto;
  final String time;

  MessageList(
    this.id,
    this.isBlock,
    this.message,
    this.senderId,
    this.senderName,
    this.senderPhoto,
    this.time,
  );

  MessageList.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as String,
        isBlock = json['isBlock'] as String,
        message = json['message'] as String,
        senderId = json['sender_id'] as String,
        senderName = json['sender_name'] as String,
        senderPhoto = json['sender_photo'] as String,
        time = json['time'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'isBlock': message,
        'message': message,
        'sender_id': senderId,
        'sender_name': senderName,
        'sender_photo': senderPhoto,
        'time': time,
      };
}
