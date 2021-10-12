import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:better/common/dialogs.dart';
import 'package:better/src/apiendpoint.dart';
import 'package:better/src/webservice.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'bottomnav.dart';
import 'myappbar.dart';
import '../common/globals.dart' as globals;

class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  _Mypage createState() => _Mypage();
}

class _Mypage extends State<Mypage> {
  late Future<List> loadData;

  String uName = '';
  String? uGender;
  String uBirthday = '';
  String uLocation = '';
  String uAbout = '';
  String uPicture = '';

  bool isphoto = false;
  late File _photoFile;

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

  var txtFontStyle = TextStyle(fontSize: 16);
  //List<OrganModel> organList = [];

  @override
  void initState() {
    super.initState();
    globals.appTitle = 'マイページ';
    globals.bottomNavSelect = 4;
    loadData = loadMyInfoData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Color.fromRGBO(210, 209, 215, 1),
          appBar: MyAppBar(
            actionType: 'mypage',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(child: Container()),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.black,
                                            onPrimary: Colors.white,
                                            padding: EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                side: BorderSide(
                                                    color: Colors.white,
                                                    width: 2)),
                                          ),
                                          child: Icon(Icons.edit, size: 18),
                                          onPressed: () {
                                            _getFromPhoto();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    image: isphoto
                                        ? DecorationImage(
                                            image: FileImage(_photoFile),
                                            fit: BoxFit.cover,
                                          )
                                        : uPicture.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(uPicture),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: AssetImage(
                                                    'images/logo.jpg'),
                                                fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(150),
                                  ),
                                ),
                                Container(width: 20),
                                Expanded(
                                    child: Container(
                                        child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 40,
                                              child: Text('氏名',
                                                  style: txtFontStyle)),
                                          Flexible(
                                              child: TextFormField(
                                            controller: TextEditingController(
                                                text: uName),
                                            decoration: txtDecoration,
                                            onChanged: (v) {
                                              uName = v;
                                            },
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 40,
                                              child: Text('性別',
                                                  style: txtFontStyle)),
                                          Flexible(
                                              child: DropdownButtonFormField(
                                            value: uGender,
                                            items: [
                                              DropdownMenuItem(
                                                  child: Text('男性'),
                                                  value: '男性'),
                                              DropdownMenuItem(
                                                  child: Text('女性'),
                                                  value: '女性'),
                                              DropdownMenuItem(
                                                  child: Text('フェム'),
                                                  value: 'フェム'),
                                            ],
                                            onChanged: (v) {
                                              uGender = v.toString();
                                            },
                                            decoration: txtDecoration,
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 40,
                                              child: Text('年齢',
                                                  style: txtFontStyle)),
                                          Flexible(
                                              child: TextFormField(
                                            controller: TextEditingController(
                                                text: uBirthday),
                                            decoration: txtDecoration,
                                            onChanged: (v) {
                                              uBirthday = v;
                                            },
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 40,
                                              child: Text('地域',
                                                  style: txtFontStyle)),
                                          Flexible(
                                              child: TextFormField(
                                            controller: TextEditingController(
                                                text: uLocation),
                                            decoration: txtDecoration,
                                            onChanged: (v) {
                                              uLocation = v;
                                            },
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 40,
                                              child: Text('趣味',
                                                  style: txtFontStyle)),
                                          Flexible(
                                              child: TextFormField(
                                            decoration: txtDecoration,
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 40,
                                              child: Text('特技',
                                                  style: txtFontStyle)),
                                          Flexible(
                                              child: TextFormField(
                                            decoration: txtDecoration,
                                          ))
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
                                Container(
                                  padding: EdgeInsets.only(left: 30, right: 20),
                                  child: Text('所持よき！数', style: txtFontStyle),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    child: Row(children: [
                                      Image(
                                          image:
                                              AssetImage('images/love01.png')),
                                      Container(width: 20),
                                      Text(
                                        '０よき！',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ]),
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding:
                                            EdgeInsets.fromLTRB(40, 12, 40, 12),
                                        primary:
                                            Color.fromRGBO(208, 89, 189, 1),
                                        onPrimary: Colors.white),
                                  ),
                                )
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          width: 240,
                          child: Text(
                            '※10よき！で好きなお相手と１０分　会話できます。',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            controller: TextEditingController(text: uAbout),
                            decoration: txtDecoration,
                            maxLines: 3,
                            onChanged: (v) {
                              uAbout = v;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          width: 250,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: Color.fromRGBO(79, 146, 225, 1)),
                                ),
                                elevation: 0,
                                primary: Colors.transparent,
                                onPrimary: Color.fromRGBO(79, 146, 225, 1)),
                            child: Text(
                              '更  新',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              saveMyInfo();
                            },
                          ),
                        )
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

  Future<List> loadMyInfoData() async {
    // if (!globals.isLogin) {
    //   Funcs().logout(context);
    // }

    Map<dynamic, dynamic> results = {};
    await Webservice().callHttpLoad(apiLoadProfile,
        {'owner_id': globals.userId}).then((v) => {results = v});

    setState(() {
      uName = results['username'] == null ? '' : results['username'];
      uBirthday =
          results['user_birthday'] == null ? '' : results['user_birthday'];
      uLocation =
          results['user_location'] == null ? '' : results['user_location'];

      if (results['user_gender'] != null) {
        if (results['user_gender'] == '男性' ||
            results['user_gender'] == '女性' ||
            results['user_gender'] == 'フェム') {
          uGender = results['user_gender'];
        }
      }
      uPicture = results['picture'] == null ? '' : results['picture'];
      uAbout = results['about_me'] == null ? '' : results['about_me'];
    });
    return [];
  }

  Future<void> saveMyInfo() async {
    bool conf = await Dialogs().confirmDialog(context, '更新しますか？');
    if (!conf) return;

    String imagename = '';

    if (isphoto) {
      //base64Image = base64Encode(_photoFile.readAsBytesSync());
      // fileName = _photoFile.path.split("/").last;
      imagename = 'user-photo' +
          DateTime.now()
              .toString()
              .replaceAll(':', '')
              .replaceAll('-', '')
              .replaceAll('.', '')
              .replaceAll(' ', '') +
          '.png';
      await Webservice().callHttpMultiPart(
          context, apiUploadPicture, _photoFile.path, imagename);
    }
    Map<dynamic, dynamic> results = {};
    await Webservice().callHttp(context, apiEditMyInfo, {
      'user_id': globals.userId,
      'username': uName,
      'user_birthday': uBirthday,
      'user_location': uLocation,
      'user_gender': uGender,
      'about_me': uAbout,
      'latitude': 'latitude',
      'longitude': 'longitude',
      'upload_image': imagename,
    }).then((value) => results = value);

    isphoto = false;
  }

  _getFromPhoto() async {
    Dialogs().infoDialog(context, '現在メンテナンス中の為、画像のアップロードが実行できません。');
    return;
    // XFile? image;

    // // if (_libType == 1) {
    // image = await ImagePicker().pickImage(source: ImageSource.camera);
    // // } else {
    // image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // // }

    // uPicture = image!.path;
    // setState(() {
    //   isphoto = true;
    //   _photoFile = File(image!.path);
    // });

    // final bytes = await File(path).readAsBytes();
    // final img.Image? image1 = img.decodeImage(bytes);
    // Dialogs().infoDialog(context, image1.toString());
  }
}
