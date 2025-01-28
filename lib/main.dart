import 'package:flutter/material.dart';
import 'package:social_test/controllers/authentication/loginController.dart';
import 'package:social_test/controllers/newsfeed/newsfeedController.dart';
import 'package:social_test/helpers/projectResources.dart';
import 'package:social_test/helpers/sharedPreference.dart';
import 'package:social_test/models/authModel.dart';
import 'package:social_test/styles/colors.dart';
import 'package:social_test/styles/theme.dart';
import 'package:social_test/views/newsfeed/newsfeedScreen.dart';

import 'views/authentication/loginScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => LoginController(),
      ),
      ChangeNotifierProvider(
        create: (_) => NewsfeedController(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    ProjectResource.navigatorKey = GlobalKey<NavigatorState>();
    checkSettings();
  }

  checkSettings() {
    SharedPref.contain('settings').then((val) {
      if (val) {
        SharedPref.read('settings').then((val) {
          if(val!=null) {
          setState(() {
            ProjectResource.settings = val!;
            ProjectResource.loggedIn = val['loggedIn'];
            ProjectResource.settingsDone = val['settings'] == 0 ? false : true;
            if (val['user'] != '') {
              ProjectResource.token = val['user']['token'];
              ///---------user data log-----------//
              print(ProjectResource.token);

            }
          });
          print(ProjectResource.settings);
          }
        });
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Social App',
        navigatorKey: ProjectResource.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: ProjectResource.loggedIn
            ? NewsfeedScreen()
            : LoginScreen()    );
  }
}
