import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Dialogs {
  Future<void> loaderDialogNormal(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }

  void infoDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            child: const Text('はい'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<bool> confirmDialog(BuildContext context, String message) async {
    final value = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('はい'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
            child: const Text('いいえ'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
    return value == true;
  }

  Future<bool> waitDialog(BuildContext context, String msg) async {
    final value = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(msg),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => {Navigator.of(context).pop(true)},
          ),
        ],
      ),
    );
    return value == true;
  }

  Future<void> followDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
