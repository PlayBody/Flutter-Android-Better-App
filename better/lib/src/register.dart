// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:better/common/dialogs.dart';
import 'package:better/src/apiendpoint.dart';
import 'package:better/src/licenseview.dart';
import 'package:better/src/webservice.dart';
import 'package:better/src/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import '../common/globals.dart' as globals;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  String userName = '';
  String comment = 'よろしくお願いします。';
  String errMsg = '';
  bool isCheck = false;

  var txtNameController = TextEditingController();
  var txtCommentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    txtCommentController.text = comment;
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          child: Scaffold(
              body: OrientationBuilder(builder: (context, orientation) {
            return Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 80),
                      width: 130,
                      child: Image(image: AssetImage('images/logo.jpg')),
                    ),
                    Container(
                      height: 40,
                    ),
                    Container(
                        child: TextFormField(
                            controller: txtNameController,
                            // onChanged: (v) {
                            //   userName = v;
                            // },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 15, 20, 0),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset(
                                  'images/person01.png',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ))),
                    Container(
                      padding: EdgeInsets.only(bottom: 15, left: 22),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '※ハンドルネームは5文字までです',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 8),
                              child: Image.asset(
                                'images/person02.png',
                                width: 34,
                                height: 32,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              child: Text('自己紹介'),
                            )
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        onChanged: (v) {
                          comment = v;
                        },
                        maxLines: 4,
                        controller: txtCommentController,
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        child: Row(
                      children: [
                        Expanded(child: Container()),
                        Container(
                          child: Checkbox(
                              value: isCheck,
                              onChanged: (v) {
                                setState(() {
                                  isCheck = v!;
                                });
                              }),
                        ),
                        Container(
                          child: Text(
                            '同意する',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(86, 137, 152, 1)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextButton(
                            child: Text('条項 & 条件',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(86, 137, 152, 1),
                                    fontWeight: FontWeight.bold)),
                            style: TextButton.styleFrom(
                              primary: Color.fromRGBO(86, 137, 152, 1),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return LicenseView(
                                    title: '利用規約', selectedUrl: apiLicenseTerm);
                              }));
                            },
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    )),
                    Container(
                      child: TextButton(
                          child: Text(
                            '& 個人情報保護方針',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(86, 137, 152, 1),
                                fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                            primary: Color.fromRGBO(86, 137, 152, 1),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return LicenseView(
                                  title: '保護方針',
                                  selectedUrl: apiLicensePrivacy);
                            }));
                          }),
                    ),
                    Container(
                      height: 30,
                    ),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        child: Text('会員登録'),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: TextStyle(fontSize: 16)),
                        onPressed: !isCheck
                            ? null
                            : () {
                                register();
                              },
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
        ));
  }

  Future<void> register() async {
    userName = txtNameController.text;
    comment = txtCommentController.text;
    if (userName == '') {
      Dialogs().infoDialog(context, 'ユーザー名を入力してください。');
      return;
    }
    if (userName.length > 5) {
      Dialogs().infoDialog(context, 'ユーザー名を5文字以内で入力してください。');
      return;
    }
    if (userName.contains('@')) {
      Dialogs().infoDialog(context, 'ユーザー名を正確に入力してください。');
      return;
    }

    Map<dynamic, dynamic> results = {};

    await Webservice().callHttp(context, apiSignUp, {
      'username': userName,
      'about_me': comment,
      'user_location': '',
      'user_birthday': '',
      'token': '',
      'latitude': '',
      'longitude': '',
      'user_gender': ''
    }).then((value) => results = value);

    if (results['result_code'] == 201) {
      Dialogs().infoDialog(context, '既に使用されているユーザーです。');
      return;
    }

    if (results['result_code'] == 200) {
      globals.userId = results['id'].toString();
      globals.userName = userName;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', globals.userId);
      prefs.setString('user_name', globals.userName);

      // Map<dynamic, dynamic> res = {};
      // await Webservice()
      //     .callHttp(context, apiLoadMain, {}).then((value) => res = value);

      // if (res['app_status'] == 0 ||
      //     res['web_link'] == null ||
      //     res['web_link'] == '') {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return Home();
      }));
      // } else {
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (BuildContext context) => MyWebView(
      //             title: "DigitalOcean",
      //             selectedUrl: res['web_link'],
      //           )));
      // }
    }
  }
}
