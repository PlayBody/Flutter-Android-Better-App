import 'dart:convert';
import 'dart:io';

import 'package:better/common/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class Webservice {
  Future<Map> callHttp(
      BuildContext context, String url, Map<String, dynamic> param) async {
    loaderDialogNormal(context);
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    final response = await ioClient.post(Uri.parse(url),
        headers: {
          "Accept": "application/json; charset=UTF-8",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: param);
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception('sever error');
    }
  }

  Future<void> callHttpMultiPart(BuildContext context, String url,
      String filename, String uploadUrl) async {
    loaderDialogNormal(context);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile(
      'picture',
      File(filename).readAsBytes().asStream(),
      File(filename).lengthSync(),
      filename: uploadUrl,
    ));

    var res = await request.send();

    Navigator.of(context).pop();
  }

  Future<Map> callHttpLoad(String url, Map<String, dynamic> param) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    final response = await ioClient.post(Uri.parse(url),
        headers: {
          "Accept": "application/json; charset=UTF-8",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: param);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      // result = jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('sever error');
    }
  }

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
}
