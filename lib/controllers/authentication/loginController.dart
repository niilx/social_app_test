/*
 *
 * @author Md. Touhidul Islam
 * @ updated at 12/14/21 4:26 PM.
 * /
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_test/helpers/routes.dart';
import 'package:social_test/helpers/sharedPreference.dart';
import 'package:social_test/models/authModel.dart';
import 'package:social_test/views/authentication/loginScreen.dart';
import 'package:social_test/views/newsfeed/newsfeedScreen.dart';

import '../../helpers/projectResources.dart';
import '../../network_manager/apis.dart';
import '../../network_manager/network_manager.dart';

class LoginController with ChangeNotifier {
  bool loading = false;
  bool passwordVisible = true;
  TextEditingController emailController = TextEditingController();
  FocusNode emailControllerNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordControllerNode = FocusNode();
  late String token;
  late int statusCodes;

  passVisibleChange() {
    passwordVisible = !passwordVisible;
    print(passwordVisible);
    notifyListeners();
  }

  clear() {
    loading = false;
    passwordVisible = true;
    passwordController.clear();
  }

  performLogin({context}) {
    loading = true;
    notifyListeners();

    var jsonData;
    jsonData = {
        'email': emailController.text.toString(),
        'password': passwordController.text.toString(),
        'token': '',
      };

    NetworkManager.postDataToApi(apiUrl: ApiEnd.loginUrl, jsonData: jsonData)
        .then((response) {
      print(response.statusCode);
      print(response.body);
      try {
        var data = json.decode(response.body);
        loading = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200) {
          final userModel = authModelFromJson(response.body);
          final userData = userModel;
          token = userModel.token??'';
          ProjectResource.token = userModel.token??'';
          ProjectResource.loggedIn = true;
          ProjectResource.settings['loggedIn'] = true;
          ProjectResource.settings['language'] = 'en';
          ProjectResource.settings['settings'] = 0;
          ProjectResource.settings['user'] = {"token": token, "data": data};
          SharedPref.remove('settings');
          SharedPref.save('settings', ProjectResource.settings);
          print(ProjectResource.settings);

          Navigator.push(
              context, SlideRightRoute(page: NewsfeedScreen()));

          ProjectResource.showToast("Signed In successfully!", false, 'center');
        } else {
          loading = false;
          ProjectResource.showToast("${data['message']}", true, 'center');
        }
      } catch (e) {
        loading = false;
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      notifyListeners();
    });
  }

  performLogout({context}) {
    loading = true;
    notifyListeners();
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Center(child: CircularProgressIndicator());
        });
    NetworkManager.postDataToApi(
            apiUrl: ApiEnd.logoutUrl, token: ProjectResource.token)
        .then((response) {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      Navigator.pop(context);
      try {
        loading = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200) {
          ProjectResource.settings['loggedIn'] = false;
          ProjectResource.loggedIn = false;
          ProjectResource.settings['user'] = "";
          print(ProjectResource.settings);
          SharedPref.save('settings', ProjectResource.settings);
          Navigator.popUntil(context, (route) => false);
          Navigator.push(context, SlideRightRoute(page: LoginScreen()));
        } else {
          ProjectResource.showToast("Something went wrong", true, 'center');
        }
      } catch (e) {
        loading = false;
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      notifyListeners();
    });
  }

}
