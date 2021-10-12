class UserModel {
  final String userId;
  final String userName;
  final String picture;
  final String follower;
  final String aboutMe;
  final String userLocation;
  final String userBirthday;
  final String userGender;
  final String userPurpose;
  final String userAtt;
  final String like;

  const UserModel({
    required this.userId,
    required this.userName,
    required this.picture,
    required this.follower,
    required this.aboutMe,
    required this.userLocation,
    required this.userBirthday,
    required this.userGender,
    required this.userPurpose,
    required this.userAtt,
    required this.like,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'],
      userName: json['username'],
      picture: json['picture'],
      follower: json['follower'].toString(),
      aboutMe: json['about_me'],
      userLocation: json['user_location'].toString(),
      userBirthday: json['user_birthday'].toString(),
      userGender: json['user_gender'].toString(),
      userPurpose: json['user_purpose'],
      userAtt: json['user_att'],
      like: json['like'],
    );
  }
}
