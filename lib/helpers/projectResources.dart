/*
 *
 * @author Md. Touhidul Islam
 * @ updated at 12/14/21 4:26 PM.
 * /
 */

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_test/helpers/routes.dart';
import 'package:social_test/styles/colors.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';


class ProjectResource {
  static late GlobalKey<NavigatorState> navigatorKey;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double fontSizeFactor = 0;
  static late BuildContext currentContext;

  static String token= '';
  static bool showOnBoard = false;
  static bool showTutorial = false;
  static Map<String, dynamic> settings = {
    'language': 'en',
    'currencyName': 'AED',
    'currencySign': 'AED',
    'shopName': '',
    'shopType': '',
    'shopDesc': '',
    'settings': 0,
    'balance': 0,
    'is_online': 0,
    'showOnBoarding': false,
    'showTutorial': false,
    'loggedIn': false,
    'user': ''
  };
  static bool loggedIn = false;
  static bool settingsDone = false;
  static int accountStatus = 0; //0-under review //1-approved //2-suspended
  // static UserModel? userDataGlobal;
  static String userImage = "";

  static void setScreenSize(BuildContext context, [var state]) {
    if (ModalRoute.of(context)!.isCurrent) {
      currentContext = context;
      //pageState = state;
    }

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    screenHeight = screenWidth < screenHeight
        ? screenHeight
        : (screenWidth / screenHeight) * screenWidth;
    fontSizeFactor = screenWidth * 0.035;
  }

  static getGapVertical({double? value}) {
    return SizedBox(
      height: value,
    );
  }

  static getGapHorizontal({double? value}) {
    return SizedBox(
      width: value,
    );
  }

  static getErrorView() {
    return Center(
      child: Text(
        "Something went wrong",
        style: TextStyle(
            fontSize: ProjectResource.fontSizeFactor * .9,
        ),
      ),
    );
  }

  static getLoaderCircular() {
    return Container(
      height: ProjectResource.screenHeight * .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }



  static DateTime? currentBackPressTime;
  static Future<bool> onWillPopExit({required BuildContext context}) {
    DateTime now = DateTime.now();

    if (Platform.isIOS) {
      print("IOS platform");
      return Future.value(false);
    } else {
      print("Android platform");
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        ProjectResource.showToast("Press again to Exit", true, "willpop");
        return Future.value(false);
      }
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  static Future<bool> onWillPopBack() {
    DateTime now = DateTime.now();

    if (Platform.isIOS) {
      print("IOS platform");
      return Future.value(false);
    } else {
      print("Android platform");
      return Future.value(true);
    }
  }
 static String timeAgo(DateTime date) {
    Duration diff = DateTime.now().difference(date);

    if (diff.inDays >= 2) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} mins ago';
    } else {
      return 'Just now';
    }
  }
 static String timeAgoShort(DateTime date) {
    Duration diff = DateTime.now().difference(date);

    if (diff.inDays >= 2) {
      return '${diff.inDays}d';
    } else if (diff.inDays == 1) {
      return '1d';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m';
    } else {
      return 'now';
    }
  }

  //Result Not Found View
  static getNoItemView(
      {context,
        required String title,
        dynamic route,
        String? routeText,
        String type = 'none'}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          type == 'none'
              ? Container()
              : type == 'noItem'
              ? Padding(
            padding: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.search_outlined,
              color: AppColors.themeColor,
              size: ProjectResource.fontSizeFactor * 2,
            ),
          )
              : Padding(
            padding: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.error_outline_outlined,
              color: AppColors.themeColor,
              size: ProjectResource.fontSizeFactor * 2,
            ),
          ),
          Text(
            title.toString(),
            style: TextStyle(
                fontSize: ProjectResource.fontSizeFactor * .96,
                color: AppColors.blackColor.withAlpha(70)),
          ),
          SizedBox(
            height: 2,
          ),
          route == null
              ? Container()
              : MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () {
                Navigator.push(context, SlideRightRoute(page: route));
              },
              child: Text(
                routeText??"Okay",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    color: AppColors.themeColor,
                    fontSize: ProjectResource.fontSizeFactor * .9),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  static notFoundView() {
    var margin = SizedBox(
      height: 10,
    );
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/error.png",
            scale: 6,
          ),
          margin,
          Text(
            "No Result Found",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20),
            textAlign: TextAlign.justify,
          ),
          margin,
          Text(
            "We can't find any item matching your search",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black54,
                fontSize: 14),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  static getImageView(
      {required BuildContext context,
        required String imgUrl,
        required Alignment alignments,
        required bool isUrl}) {
    return showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.1),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return SafeArea(child:
        StatefulBuilder(// You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Material(
                child: Container(
                  height: ProjectResource.screenHeight,
                  width: ProjectResource.screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        child: isUrl
                            ? CachedNetworkImage(
                          imageUrl: imgUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.contain),
                            ),
                          ),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                              height: ProjectResource.screenHeight * .3,
                              child:
                              Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Container(
                              height: ProjectResource.screenHeight * .3,
                              child: Center(child: Icon(Icons.error))),
                        )
                            : Image.file(
                          File(imgUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                          top: 13,
                          left: 10,
                          child: BackButton())
                    ],
                  ),
                ),
              );
            }));
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: anim,
          child: child,
          alignment: alignments == null ? Alignment.center : alignments,
        );
      },
    );
  }

  static showToast(String text, bool isError, [String? gravity]) {
    Color textColor = AppColors.whiteColor;
    Color backColor = AppColors.themeColor;
    ToastContext().init(ProjectResource.currentContext);
    if (isError) {
      textColor = AppColors.whiteColor;
      backColor = AppColors.redColor;
    }
    if (gravity == "top") {
      Toast.show(text,
          duration: 5,
          gravity: Toast.top,
          backgroundColor: backColor,
          webTexColor: textColor);
    }
    if (gravity == "center") {
      Toast.show(text,
          duration: 5,
          gravity: Toast.center,
          backgroundColor: backColor,
          webTexColor: textColor);
    } else if (gravity == "location") {
      Toast.show(text,
          duration: 3,
          gravity: Toast.center,
          backgroundColor: backColor,
          webTexColor: textColor);
    } else if (gravity == "willpop") {
      Toast.show(
        text,
        duration: 5,
        gravity: Toast.bottom,
        backgroundColor: Colors.black54,
        webTexColor: Colors.white,
      );
    } else if (gravity == "switch") {
      Toast.show(
        text,
        duration: 5,
        gravity: Toast.center,
        backgroundColor: Colors.black54,
        webTexColor: Colors.white,
      );
    } else {
      Toast.show(
        text,
        duration: 5,
        gravity: Toast.bottom,
        backgroundColor: Colors.black54,
        webTexColor: Colors.white,
      );
    }
  }

  static launchURL(String _url, {String? mode}) async {
    if (await canLaunchUrl(Uri.parse(_url))) {
      await launchUrl(Uri.parse(_url), mode:
      mode != null?
      LaunchMode.externalApplication: LaunchMode.platformDefault,
      );
    } else {
      ScaffoldMessenger.of(ProjectResource.currentContext).showSnackBar(
          const SnackBar(content: Text("Could not launch Url")));
    }
  }

  static checkInternet() async {
    var internetStatus = true;
    var serverStatus = true;

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 15));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetStatus = true;
        print('connected');
      }
    } on SocketException catch (_) {
      print(_);
      internetStatus = false;
    } on TimeoutException catch (_) {
      internetStatus = false;
    }
    if (internetStatus == true) {
      return 'all_connected';
    } else if (internetStatus == false) {
      return "no_internet";
    }
  }

  static internetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print(result);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
