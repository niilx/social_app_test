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
import 'package:social_test/models/commentListModel.dart';
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
  bool loadingLike = false;
  bool loadingComment = false;
  bool loadingCommentReply = false;
  bool loadingCreateComment = false;
  bool loadingCreateReply = false;
  bool showReactions = false;
  List<CommunityListModel> newsFeedList = [];
  late String token;
  late int statusCodes;
  String lastDataId = "";
  String likeFeedId = "";
  String replyCommentId = "";

  TextEditingController postController = TextEditingController();
  String selectedGradientBg = "";
  bool showSetBg = false;
  FocusNode postControllerNode = FocusNode();

  List<CommentListModel> commentList = [];
  List<CommentListModel> commentReplyList = [];
  TextEditingController commentController = TextEditingController();

  init() {
    loading = false;
    loadingMore = false;
    loadingError = false;
    loadingLike = false;
    showReactions = false;
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

  initComment() {
    replyCommentId = "";
    loadingComment = false;
    loadingCommentReply = false;
    loadingCreateComment = false;
    loadingCreateReply = false;
    commentList.clear();
    commentReplyList.clear();
    commentController.clear();
    notifyListeners();
  }

  removePopup(){
   showReactions = false;
   notifyListeners();
  }

  toggleSetBg(){
    showSetBg = !showSetBg;
    notifyListeners();
  }

  selectGradient(int index){
    if(selectedGradientBg == AppColors.feedBackGroundGradientColors[index]){
      selectedGradientBg = "";
    }else{
      selectedGradientBg = AppColors.feedBackGroundGradientColors[index];
    }
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

  //Post Get
  getNewsfeedData({context, required bool isMore, bool update = false}) {
    if(!isMore){
      if(!update) {
        loading = true;
      }
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
          if(update){
            newsFeedList.clear();
          }
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

  //Post Comments
  getFeedCommentData({context, required String feedId, bool update = false}) {
      if(!update) {
        loadingComment = true;
      }
    notifyListeners();

    NetworkManager.getDataFromApi(apiUrl: ApiEnd.commentListUrl+feedId,
    token: ProjectResource.token
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);
      try {
        var data = json.decode(response.body);
        loadingComment = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200) {
          final commentDataList = commentListModelFromJson(response.body);
          commentList = commentDataList;
        } else {
          loadingComment = false;
          ProjectResource.showToast("${data['message']}", true, 'center');
        }
      } catch (e) {
        loadingComment = false;
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      notifyListeners();
    });
  }

  getFeedCommentReplyData({context, required String commentId, bool update = false}) {
      if(!update) {
        loadingCommentReply = true;
        replyCommentId = commentId;
      }
    notifyListeners();

    NetworkManager.getDataFromApi(apiUrl: ApiEnd.commentReplyListUrl+commentId,
    token: ProjectResource.token
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);
      try {
        var data = json.decode(response.body);
        loadingCommentReply = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200) {
          final commentDataList = commentListModelFromJson(response.body);
          for(var item in commentDataList){
            if(!commentReplyList.contains(item)){
              commentReplyList.add(item);
            }
          }
          replyCommentId = "";
        } else {
          loadingCommentReply = false;
          ProjectResource.showToast("${data['message']}", true, 'center');
        }
      } catch (e) {
        loadingCommentReply = false;
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      notifyListeners();
    });
  }

  //Post Reaction
  createUpdateLikeData({context, required String feedId, required String reactionType,
    required String action}) {
    removePopup();
    loadingLike = true;
    likeFeedId = feedId;
    notifyListeners();

    var jsonData;
    jsonData = {
      'feed_id': feedId,
      'reaction_type': reactionType,
      'action': action, //deleteOrCreate
      'reactionSource': 'COMMUNITY'
    };

    NetworkManager.postDataToApi(apiUrl: ApiEnd.createUpdateLikeUrl, jsonData: jsonData,
        token: ProjectResource.token
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);
      try {
        var data = json.decode(response.body);
        loadingLike = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200) {
          lastDataId = "";
          getNewsfeedData(isMore: false, update: true);
        } else {
          loadingLike = false;
          ProjectResource.showToast("${data['message']}", true, 'center');
        }
      } catch (e) {
        loadingLike = false;
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      likeFeedId = "";
      notifyListeners();
    });
  }

  //Post Create
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

  //Post Comment
  createCommentData({context, required String feedId, required String feedUserId}) {
    loadingCreateComment = true;
    notifyListeners();

    var jsonData;
    jsonData = {
      'feed_id': feedId,
      'feed_user_id': feedUserId,
      'comment_txt': commentController.text,
      'commentSource': "COMMUNITY",
    };

    NetworkManager.postDataToApi(apiUrl: ApiEnd.createCommentUrl, jsonData: jsonData,
    token: ProjectResource.token
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);
      try {
        var data = json.decode(response.body);
        loadingCreateComment = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200) {
          commentController.clear();
          getFeedCommentData(feedId: feedId, update: true);
        } else {
          loadingCreateComment = false;
          ProjectResource.showToast("${data['message']}", true, 'center');
        }
      } catch (e) {
        loadingCreateComment = false;
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      notifyListeners();
    });
  }

  //Comment Reply
  createCommentReplyData({context, required String feedId,required String parentId, required String feedUserId}) {
    loadingCreateComment = true;
    notifyListeners();

    var jsonData;
    jsonData = {
      'feed_id': feedId,
      'feed_user_id': feedUserId,
      'comment_txt': commentController.text,
      'commentSource': "COMMUNITY",
      'parrent_id': parentId,
    };

    NetworkManager.postDataToApi(apiUrl: ApiEnd.createCommentUrl, jsonData: jsonData,
    token: ProjectResource.token
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);
      try {
        var data = json.decode(response.body);
        loadingCreateComment = false;
        statusCodes = response.statusCode;
        if (statusCodes == 200) {
          getFeedCommentData(feedId: feedId, update: true);
        } else {
          loadingCreateComment = false;
          ProjectResource.showToast("${data['message']}", true, 'center');
        }
      } catch (e) {
        loadingCreateComment = false;
        ProjectResource.showToast("Something went wrong", true, 'center');
      }
      notifyListeners();
    });
  }

}
