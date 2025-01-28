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
import 'package:social_test/models/communityListModel.dart';
import 'package:social_test/styles/colors.dart';
import 'package:social_test/views/authentication/loginScreen.dart';
import 'package:social_test/views/newsfeed/newsfeedScreen.dart';

import '../../helpers/projectResources.dart';
import '../../network_manager/apis.dart';
import '../../network_manager/network_manager.dart';

class NewsfeedController with ChangeNotifier {
  bool loading = false;
  bool loadingMore = false;
  bool loadingError = false;
  bool loadingPost = false;
  List<CommunityListModel> newsFeedList = [];
  late String token;
  late int statusCodes;
  String lastDataId = "";

  TextEditingController postController = TextEditingController();
  String selectedGradientBg = "";
  FocusNode postControllerNode = FocusNode();

  init() {
    loading = false;
    loadingMore = false;
    loadingError = false;
    lastDataId = "";
    newsFeedList.clear();
    notifyListeners();
  }

  initPost() {
    loadingPost = false;
    postController.clear();
    selectedGradientBg = "";
    notifyListeners();
  }

  loadingState(bool isMore){
    if(!isMore){
      loading = false;
      loadingError = true;
    }else{
      loadingMore = false;
    }
  }

  getNewsfeedData({context, required bool isMore}) {
    if(!isMore){
      loading = true;
    }else {
      loadingMore = true;
    }
    notifyListeners();

    var jsonData;
    jsonData = {
      'community_id': "2914",
      'space_id': "5883",
      'more': lastDataId,
    };

    NetworkManager.postDataToApi(apiUrl: ApiEnd.feedListUrl, jsonData: jsonData,
    token: ProjectResource.token
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);
      try {
        var data = json.decode(response.body);
        loading = false;
        loadingMore = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200) {
          final newsFeedListData = communityListModelFromJson(response.body);
          newsFeedList.addAll(newsFeedListData);
          lastDataId = newsFeedList[newsFeedList.length-1].id.toString();
        } else {
          loadingState(isMore);
          ProjectResource.showToast("${data['message']}", true, 'center');
        }
      } catch (e) {
        loadingState(isMore);
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      notifyListeners();
    });
  }


  selectGradient(int index){
    selectedGradientBg = AppColors.feedBackGroundGradientColors[index];
    notifyListeners();
  }

  createPostData({context}) {
    loadingPost = true;
    notifyListeners();

    var jsonData;
    jsonData = {
      'community_id': "2914",
      'space_id': "5883",
      'uploadType': 'text',
      'activity_type': 'group',
      'is_background': '0',
      'feed_txt': postController.text.toString(),
      'bg_color': selectedGradientBg.toString()
    };

    NetworkManager.postDataToApi(apiUrl: ApiEnd.createPostUrl, jsonData: jsonData,
    token: ProjectResource.token
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);
      try {
        var data = json.decode(response.body);
        loadingPost = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200 || statusCodes == 201) {
          ProjectResource.showToast("Post creation success!", false, 'center');
          Navigator.pop(context,true);
        } else {
          loadingPost = false;
          ProjectResource.showToast("${data['message']}", true, 'center');
        }
      } catch (e) {
        loadingPost = false;
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      notifyListeners();
    });
  }

}
