import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'apiendpoint.dart';
import 'bottomnav.dart';
import 'chat.dart';
import 'myappbar.dart';
import '../common/globals.dart' as globals;
import '../common/dialogs.dart';
import 'webservice.dart';

class Profile extends StatefulWidget {
  final String profileId;
  const Profile({required this.profileId, Key? key}) : super(key: key);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  late Future<List> loadData;
  String userName = '';
  String picture = '';
  String birthday = '';
  String gender = '';
  String aboutMe = '';
  String location = '';

  Map<String, dynamic> url = {};
  int urlCnt = 1;

  bool isPublicMode = false;

  var txtDecoration = InputDecoration(
    contentPadding: EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(6.0),
    ),
  );

  var chatButtonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
      primary: Color.fromRGBO(67, 116, 195, 1),
      onPrimary: Colors.white);

  var txtFontStyle = TextStyle(fontSize: 16);
  //List<OrganModel> organList = [];

  @override
  void initState() {
    super.initState();
    globals.appTitle = 'プロフィール';
    globals.bottomNavSelect = 1;
    loadData = loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Color.fromRGBO(210, 209, 215, 1),
          appBar: MyAppBar(
            actionType: 'profile',
            isLeading: true,
            blockTap: () => setBlockUser(),
            newsTap: () => sendNewsUser(),
          ),
          body: Container(
              child: FutureBuilder<List>(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: picture.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(picture),
                                            fit: BoxFit.cover)
                                        : DecorationImage(
                                            image:
                                                AssetImage('images/logo.jpg'),
                                            fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(150),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 1),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 40,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1),
                                                          color: Colors.white,
                                                          child: Text(userName,
                                                              style:
                                                                  txtFontStyle))),
                                                  Expanded(
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 40,
                                                          color: Colors.white,
                                                          child: Text('')))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 40,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1),
                                                          color: Colors.white,
                                                          child: Text(
                                                              birthday + '歳',
                                                              style:
                                                                  txtFontStyle))),
                                                  Expanded(
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 40,
                                                          color: Colors.white,
                                                          child:
                                                              Text(location)))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )))
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(child: Container()),
                              Container(
                                child: ElevatedButton(
                                    style: chatButtonStyle,
                                    child: Row(
                                      children: [
                                        Image(
                                            image:
                                                AssetImage('images/video.png')),
                                        Container(width: 10),
                                        Text('ビデオ通話')
                                      ],
                                    ),
                                    onPressed: isPublicMode
                                        ? () => goWebView()
                                        : () {
                                            Dialogs().infoDialog(context,
                                                'よき！の数が足りていません。\nよき！を貯めると電話ができるよ');
                                          }),
                              ),
                              Container(
                                width: 15,
                              ),
                              Container(
                                child: ElevatedButton(
                                    style: chatButtonStyle,
                                    child: Row(
                                      children: [
                                        Image(
                                            image:
                                                AssetImage('images/fly.png')),
                                        Container(width: 10),
                                        Text('チャット')
                                      ],
                                    ),
                                    onPressed: isPublicMode
                                        ? () => goWebView()
                                        : () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return Chat(
                                                userId: widget.profileId,
                                                userName: userName,
                                              );
                                            }));
                                          }),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [Text(aboutMe)]),
                          height: 100,
                        ),
                        Container(
                          width: 200,
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                            child: Row(children: [
                              Image(image: AssetImage('images/love01.png')),
                              Container(width: 20),
                              Text(
                                '０よき！',
                                style: TextStyle(fontSize: 16),
                              )
                            ]),
                            onPressed: () {
                              Dialogs().infoDialog(
                                  context, 'よき！しました。\nお相手にもよき！をリクエストしてみましょう。');
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                                primary: Color.fromRGBO(208, 89, 189, 1),
                                onPrimary: Colors.white),
                          ),
                        ),
                      ],
                    )));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          )),
          bottomNavigationBar: BottomNav()),
    );
  }

  Future<List> loadUserInfo() async {
    Map<dynamic, dynamic> results = {};
    await Webservice().callHttpLoad(apiLoadProfile,
        {'owner_id': widget.profileId}).then((v) => {results = v});
    setState(() {
      userName = results['username'];
      picture = results['picture'];
      aboutMe = results['about_me'];
      location = results['user_location'];
      birthday = results['user_birthday'];
    });

    Map<dynamic, dynamic> res = {};
    await Webservice().callHttp(
        context, apiLoadMain, {'app_key': '3'}).then((value) => res = value);

    if (res['app_status'].toString() == '0') {
      isPublicMode = false;
    } else {
      isPublicMode = true;
      url = res['web_link'];
      urlCnt = int.parse(res['link_cnt'].toString());
    }

    return [];
  }

  Future<void> setBlockUser() async {
    Map<dynamic, dynamic> results = {};
    await Webservice().callHttp(context, apiBlockUser, {
      'block_user_id': widget.profileId,
      'owner_id': globals.userId,
    }).then((v) => results = v);
    await Dialogs().waitDialog(context, 'ブロックしました。');
    Navigator.pop(context);
  }

  Future<void> sendNewsUser() async {
    Map<dynamic, dynamic> results = {};
    await Webservice().callHttp(context, apiBlockUser, {
      'block_user_id': widget.profileId,
      'owner_id': globals.userId,
    }).then((v) => results = v);
    await Dialogs().waitDialog(context, '通報しました。');
    Navigator.pop(context);
  }

  void goWebView() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          ' お相手とのやりとりをするには専用アプリが必要です。',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Row(children: [
            Expanded(child: Container()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue, onPrimary: Colors.white),
              child: const Text('インストール'),
              onPressed: () {
                Navigator.of(context).pop();
                _launchInBrowser(url);
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => MyWebView(
                //           title: "Better",
                //           selectedUrl: url,
                //         )));
              },
            ),
            Expanded(child: Container()),
          ]),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(url) async {
    Random random = new Random();
    int urlIndex = 1;
    bool isRepeat = true;
    String linkUrl = '';

    while (isRepeat) {
      urlIndex = random.nextInt(urlCnt) + 1;
      linkUrl =
          url[urlIndex.toString()] == null ? '' : url[urlIndex.toString()];

      if (linkUrl != '') isRepeat = false;
    }
    //const url =
    //  'https://play.google.com/store/apps/details?id=llc.itk.jump&referrer=adjust_reftag%3DcnQW0tQC6n9dl%26utm_source%3D%25E3%2580%2590SMAD%25E3%2580%2591%25';
    if (await canLaunch(linkUrl)) {
      await launch(linkUrl);
    } else {
      throw 'Could not launch $linkUrl';
    }
  }
}
