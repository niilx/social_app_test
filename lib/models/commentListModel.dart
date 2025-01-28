// To parse this JSON data, do
//
//     final commentListModel = commentListModelFromJson(jsonString);

import 'dart:convert';

List<CommentListModel> commentListModelFromJson(String str) => List<CommentListModel>.from(json.decode(str).map((x) => CommentListModel.fromJson(x)));

String commentListModelToJson(List<CommentListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentListModel {
  int? id;
  int? schoolId;
  int? feedId;
  int? userId;
  int? replyCount;
  int? likeCount;
  String? commentTxt;
  dynamic parrentId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic file;
  dynamic privateUserId;
  int? isAuthorAndAnonymous;
  dynamic gift;
  dynamic sellerId;
  dynamic giftedCoins;
  List<dynamic>? replies;
  dynamic privateUser;
  User? user;
  List<dynamic>? totalLikes;
  List<dynamic>? reactionTypes;
  dynamic commentlike;

  CommentListModel({
    this.id,
    this.schoolId,
    this.feedId,
    this.userId,
    this.replyCount,
    this.likeCount,
    this.commentTxt,
    this.parrentId,
    this.createdAt,
    this.updatedAt,
    this.file,
    this.privateUserId,
    this.isAuthorAndAnonymous,
    this.gift,
    this.sellerId,
    this.giftedCoins,
    this.replies,
    this.privateUser,
    this.user,
    this.totalLikes,
    this.reactionTypes,
    this.commentlike,
  });

  factory CommentListModel.fromJson(Map<String, dynamic> json) => CommentListModel(
    id: json["id"],
    schoolId: json["school_id"],
    feedId: json["feed_id"],
    userId: json["user_id"],
    replyCount: json["reply_count"],
    likeCount: json["like_count"],
    commentTxt: json["comment_txt"],
    parrentId: json["parrent_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    file: json["file"],
    privateUserId: json["private_user_id"],
    isAuthorAndAnonymous: json["is_author_and_anonymous"],
    gift: json["gift"],
    sellerId: json["seller_id"],
    giftedCoins: json["gifted_coins"],
    replies: json["replies"] == null ? [] : List<dynamic>.from(json["replies"]!.map((x) => x)),
    privateUser: json["private_user"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    totalLikes: json["totalLikes"] == null ? [] : List<dynamic>.from(json["totalLikes"]!.map((x) => x)),
    reactionTypes: json["reaction_types"] == null ? [] : List<dynamic>.from(json["reaction_types"]!.map((x) => x)),
    commentlike: json["commentlike"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "school_id": schoolId,
    "feed_id": feedId,
    "user_id": userId,
    "reply_count": replyCount,
    "like_count": likeCount,
    "comment_txt": commentTxt,
    "parrent_id": parrentId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "file": file,
    "private_user_id": privateUserId,
    "is_author_and_anonymous": isAuthorAndAnonymous,
    "gift": gift,
    "seller_id": sellerId,
    "gifted_coins": giftedCoins,
    "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x)),
    "private_user": privateUser,
    "user": user?.toJson(),
    "totalLikes": totalLikes == null ? [] : List<dynamic>.from(totalLikes!.map((x) => x)),
    "reaction_types": reactionTypes == null ? [] : List<dynamic>.from(reactionTypes!.map((x) => x)),
    "commentlike": commentlike,
  };
}

class User {
  int? id;
  String? fullName;
  String? profilePic;
  String? userType;
  Meta? meta;

  User({
    this.id,
    this.fullName,
    this.profilePic,
    this.userType,
    this.meta,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    profilePic: json["profile_pic"],
    userType: json["user_type"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "profile_pic": profilePic,
    "user_type": userType,
    "meta": meta?.toJson(),
  };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}
