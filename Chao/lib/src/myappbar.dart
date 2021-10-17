// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:Chao/common/functions.dart';
import 'package:flutter/material.dart';

import '../common/globals.dart' as globals;
// Set up a mock HTTP client.

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? actionType;
  final bool? isLeading;
  final GestureTapCallback? blockTap;
  final GestureTapCallback? newsTap;
  const MyAppBar(
      {this.actionType, this.isLeading, this.blockTap, this.newsTap, Key? key})
      : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      centerTitle: true,
      automaticallyImplyLeading: isLeading == null ? false : isLeading!,
      title: Text(
        globals.appTitle,
        style: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (actionType == 'mypage')
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0, onPrimary: Colors.white),
              onPressed: () {
                Funcs().logout(context);
              },
              child: Container(child: Icon(Icons.power_settings_new))),
        if (actionType == 'profile')
          Container(
              width: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      elevation: 0,
                      onPrimary: Colors.white),
                  onPressed: blockTap,
                  child: Container(child: Icon(Icons.person_off_outlined)))),
        if (actionType == 'profile')
          Container(
              margin: EdgeInsets.only(right: 15),
              width: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      elevation: 0,
                      onPrimary: Colors.white),
                  onPressed: newsTap,
                  child: Container(child: Icon(Icons.message)))),
      ],
    );
  }
}
