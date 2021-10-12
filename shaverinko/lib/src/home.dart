import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'apiendpoint.dart';
import 'bottomnav.dart';
import 'myappbar.dart';
import '../common/globals.dart' as globals;
import 'profile.dart';
import 'usermodel.dart';
import 'webservice.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  late Future<List> loadData;
  Future<String>? permissionStatusFuture;

  bool isAttendance = false;
  List<UserModel> userList = [];

  @override
  void initState() {
    super.initState();
    globals.appTitle = 'ホーム';
    globals.bottomNavSelect = 1;
    permissionStatusFuture = loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: MyAppBar(),
          body: OrientationBuilder(builder: (context, orientation) {
            return FutureBuilder<String>(
              future: permissionStatusFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          child: GridView.count(
                              padding: EdgeInsets.only(top: 30, bottom: 30),
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 30,
                              childAspectRatio: 0.9,
                              children: [
                                ...userList.map((e) => HomeListTile(
                                    item: e,
                                    tapFunc: () =>
                                        goProfile(context, e.userId))),
                              ]),
                        )),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              },
            );
          }),
          bottomNavigationBar: BottomNav()),
    );
  }

  Future<void> goProfile(BuildContext context, String id) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Profile(
        profileId: id,
      );
    }));
    loadHomeData();
  }

  Future<String> loadHomeData() async {
    // var permisiioncamera = await Permission.camera.status;

    // var permisionCamera = await Permission.camera.status;
    // print(permisionCamera);
    //var permisionMic = await Permission.microphone.request();

    Map<dynamic, dynamic> results = {};
    await Webservice()
        .callHttpLoad(apiLoadUsers, {}).then((v) => {results = v});

    Map<dynamic, dynamic> blockresults = {};
    await Webservice().callHttpLoad(apiGetBlockUser,
        {'owner_id': globals.userId}).then((v) => {blockresults = v});
    userList = [];
    setState(() {
      var foo;
      for (var item in results['user_info']) {
        if (item['id'].toString() != globals.userId) {
          foo = blockresults['follower_info']
              .where((element) => element['block_user_id'] == item['id'])
              .toList();
          if (foo.length < 1) {
            userList.add(UserModel.fromJson(item));
          }
        }
      }
    });
    return '';
  }
}

class HomeListTile extends StatelessWidget {
  final item;
  final tapFunc;
  const HomeListTile({required this.item, required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            child: Container(
              width: (MediaQuery.of(context).size.width - 30) / 2,
              height: (MediaQuery.of(context).size.width - 60) / 2,
              decoration: BoxDecoration(
                image: !item.picture.isEmpty
                    ? DecorationImage(
                        image: NetworkImage(item.picture), fit: BoxFit.cover)
                    : DecorationImage(
                        image: AssetImage('images/logo.jpg'),
                        fit: BoxFit.cover),
                // image: DecorationImage(
                //     image: NetworkImage(item.picture), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
            onTap: tapFunc,
            // onTap: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (_) {
            //     return Profile(
            //       profileId: item.userId,
            //     );
            //   }));
            // },
          ),
          Center(
            child: Text(
              item.userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
