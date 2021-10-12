import 'package:better/src/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class Funcs {
  void logout(BuildContext context) {
    globals.userId = '';

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Register();
    }));
  }
}
