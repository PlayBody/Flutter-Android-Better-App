import 'package:flutter/material.dart';

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
