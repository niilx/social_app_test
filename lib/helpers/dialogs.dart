
import 'package:flutter/material.dart';
import 'package:social_test/helpers/projectResources.dart';

import '../styles/colors.dart';

class Dialogs {
  static logoutDialog(BuildContext context,
      {required VoidCallback onResponse,
        required String title,
        required String content,
        required String buttonText}) {
    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: Text(title),
          alignment: Alignment.center,
          content: Text(
            content,
            style: TextStyle(
              color: AppColors.blackColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => AppColors.whiteColor),
                  foregroundColor: WidgetStateProperty.resolveWith(
                          (states) => AppColors.blackColor)
                ),
                onPressed: () => onResponse(),
                child: Text(
                  "Yes",
                )),
            TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => AppColors.themeColor),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "No",
                  style: TextStyle(color: AppColors.whiteColor),
                )),
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: anim,
          child: child,
        );
        // return SlideTransition(
        //   position: Tween(begin: Offset(-1, 0), end: Offset(0, 0)).animate(anim1),
        //   child: child,
        // );
      },
    );
  }
}