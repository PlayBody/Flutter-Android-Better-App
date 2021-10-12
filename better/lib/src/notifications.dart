import 'package:better/src/apiendpoint.dart';
import 'package:better/src/chat.dart';
import 'package:better/src/profile.dart';
import 'package:better/src/usermodel.dart';
import 'package:better/src/webservice.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bottomnav.dart';
import 'myappbar.dart';
import '../common/globals.dart' as globals;

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _Notifications createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  bool isAttendance = false;
  @override
  void initState() {
    super.initState();

    globals.appTitle = '通知';
    globals.bottomNavSelect = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: MyAppBar(),
      body: OrientationBuilder(builder: (context, orientation) {
        return Container();
      }),
      bottomNavigationBar: BottomNav(),
    ));
  }
}
