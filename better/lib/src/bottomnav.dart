import 'package:better/src/chatlist.dart';
import 'package:better/src/mypage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import '../common/globals.dart' as globals;
import 'notifications.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Container(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        BottomNavItem(
            label: 'ホーム',
            icon: Icons.home_outlined,
            isActive: globals.bottomNavSelect == 1,
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Home();
                }))),
        BottomNavItem(
            label: 'メッセージ',
            icon: Icons.chat_outlined,
            isActive: globals.bottomNavSelect == 2,
            onTap: () => //Navigator.of(context).push(_createRoute(ChatList()))
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ChatList();
                }))),
        BottomNavItem(
            label: '通知',
            icon: Icons.notifications_none_outlined,
            isActive: globals.bottomNavSelect == 3,
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Notifications();
                }))),
        BottomNavItem(
            label: 'マイページ',
            icon: Icons.person_outlined,
            isActive: globals.bottomNavSelect == 4,
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Mypage();
                }))),
      ])),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final GestureTapCallback? onTap;
  final bool isActive;

  const BottomNavItem(
      {required this.label,
      required this.icon,
      required this.onTap,
      required this.isActive,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(224, 224, 224, 1),
              elevation: 0,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0),
              ),
              textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight
                      .w600), // double.infinity is the width and 30 is the height
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  this.icon,
                  color:
                      isActive ? Color.fromRGBO(230, 131, 136, 1) : Colors.grey,
                  size: 26,
                ),
                Container(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isActive
                            ? Color.fromRGBO(230, 131, 136, 1)
                            : Colors.grey,
                      ),
                    ))
              ],
            ),
            onPressed: onTap,
          ))),
    );
  }
}
