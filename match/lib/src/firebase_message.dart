class Message {
  final String image;
  final String message;
  final String name;
  final String photo;
  final String senderId;
  final String time;

  Message(this.image, this.message, this.name, this.photo, this.senderId,
      this.time);

  Message.fromJson(Map<dynamic, dynamic> json)
      : image = json['image'] as String,
        message = json['message'] as String,
        name = json['name'] as String,
        photo = json['photo'] as String,
        senderId = json['sender_id'] as String,
        time = json['time'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'image': image,
        'message': message,
        'name': name,
        'photo': photo,
        'sender_id': senderId,
        'time': time,
      };
}
