import 'package:firebase_core/firebase_core.dart';
import 'src/home.dart';
import 'src/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  // ignore: override_on_non_overriding_member
  void exitFullscreen() {
    print('exit');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //exitFullScreen();
    //enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(primarySwatch: createMaterialColor(Color(0xFFfedcff))),
      theme: ThemeData(primarySwatch: Colors.red),
      home: AppInit(), //AppInit(),
      routes: <String, WidgetBuilder>{
        '/Register': (BuildContext context) => Register(),
        '/Home': (BuildContext context) => Home(),
      },
    );
  }
}

class AppInit extends StatefulWidget {
  const AppInit({Key? key}) : super(key: key);

  @override
  _AppInit createState() => _AppInit();
}

class _AppInit extends State<AppInit> {
  late Future<List> loadData;
  bool isVersionOk = false;
  PermissionStatus? _permissionStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => setPermission(context));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(backgroundColor: Colors.transparent, body: Container()),
    );
  }

  Future<void> setPermission(context) async {
    // await showDialog(
    //     context: context,
    //     builder: (BuildContext context) => CupertinoAlertDialog(
    //           title: Text('Camera Permission'),
    //           content: Text(
    //               'This app needs camera access to take pictures for upload user profile photo'),
    //           actions: <Widget>[
    //             CupertinoDialogAction(
    //               child: Text('Deny'),
    //               onPressed: () => Navigator.of(context).pop(),
    //             ),
    //             CupertinoDialogAction(
    //               child: Text('Settings'),
    //               onPressed: () => Navigator.of(context).pop(),
    //             ),
    //           ],
    //         ));

    // if (await Permission.camera.request().isGranted) {
    //   _permissionStatus = await Permission.camera.status;
    // }
    // setState(() {});
    await Permission.camera.request();
    await Permission.microphone.request();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await isFirstTime()) {
      Navigator.pushNamed(context, '/Register');
    } else {
      globals.userId = prefs.getString('user_id')!;
      globals.userName = prefs.getString('user_name')!;
      //prefs.remove('user_id');

      // prefs.remove('user_id');
      // Map<dynamic, dynamic> res = {};
      // await Webservice()
      //     .callHttp(context, apiLoadMain, {}).then((value) => res = value);

      // if (res['app_status'] == 0 ||
      //     res['web_link'] == null ||
      //     res['web_link'] == '') {
      Navigator.pushNamed(context, '/Home');
      // } else {
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (BuildContext context) => MyWebView(
      //             title: "DigitalOcean",
      //             selectedUrl: res['web_link'],
      //           )));
      // }
    }
  }

  Future<bool> isFirstTime() async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('user_id') == null ||
        prefs.getString('user_name') == null) {
      return true;
    } else {
      return false;
    }
  }
}
