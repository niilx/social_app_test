// To parse this JSON data, do
//
//     final communityListModel = communityListModelFromJson(jsonString);

import 'dart:convert';

List<CommunityListModel> communityListModelFromJson(String str) => List<CommunityListModel>.from(json.decode(str).map((x) => CommunityListModel.fromJson(x)));

String communityListModelToJson(List<CommunityListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommunityListModel {
  int? id;
  int? schoolId;
  int? userId;
  dynamic courseId;
  int? communityId;
  dynamic groupId;
  String? feedTxt;
  Status? status;
  String? slug;
  String? title;
  ActivityType? activityType;
  int? isPinned;
  FileType? fileType;
  List<dynamic>? files;
  int? likeCount;
  int? commentCount;
  int? shareCount;
  int? shareId;
  MetaDataClass? metaData;
  DateTime? createdAt;
  DateTime? updatedAt;
  FeedPrivacy? feedPrivacy;
  int? isBackground;
  String? bgColor;
  dynamic pollId;
  dynamic lessonId;
  int? spaceId;
  dynamic videoId;
  dynamic streamId;
  dynamic blogId;
  dynamic scheduleDate;
  String? timezone;
  int? isAnonymous;
  dynamic meetingId;
  dynamic sellerId;
  DateTime? publishDate;
  bool? isFeedEdit;
  String? name;
  String? pic;
  int? uid;
  int? isPrivateChat;
  User? user;
  dynamic group;
  dynamic poll;
  List<LikeType>? likeType;
  Like? like;
  dynamic follow;
  dynamic savedPosts;
  List<dynamic>? comments;
  PurpleMeta? meta;

  CommunityListModel({
    this.id,
    this.schoolId,
    this.userId,
    this.courseId,
    this.communityId,
    this.groupId,
    this.feedTxt,
    this.status,
    this.slug,
    this.title,
    this.activityType,
    this.isPinned,
    this.fileType,
    this.files,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.shareId,
    this.metaData,
    this.createdAt,
    this.updatedAt,
    this.feedPrivacy,
    this.isBackground,
    this.bgColor,
    this.pollId,
    this.lessonId,
    this.spaceId,
    this.videoId,
    this.streamId,
    this.blogId,
    this.scheduleDate,
    this.timezone,
    this.isAnonymous,
    this.meetingId,
    this.sellerId,
    this.publishDate,
    this.isFeedEdit,
    this.name,
    this.pic,
    this.uid,
    this.isPrivateChat,
    this.user,
    this.group,
    this.poll,
    this.likeType,
    this.like,
    this.follow,
    this.savedPosts,
    this.comments,
    this.meta,
  });

  factory CommunityListModel.fromJson(Map<String, dynamic> json) => CommunityListModel(
    id: json["id"],
    schoolId: json["school_id"],
    userId: json["user_id"],
    courseId: json["course_id"],
    communityId: json["community_id"],
    groupId: json["group_id"],
    feedTxt: json["feed_txt"],
    status: statusValues.map[json["status"]]!,
    slug: json["slug"],
    title: json["title"],
    activityType: activityTypeValues.map[json["activity_type"]]!,
    isPinned: json["is_pinned"],
    fileType: fileTypeValues.map[json["file_type"]],
    files: json["files"] == null ? [] : List<dynamic>.from(json["files"]!.map((x) => x)),
    likeCount: json["like_count"],
    commentCount: json["comment_count"],
    shareCount: json["share_count"],
    shareId: json["share_id"],
    metaData: json["meta_data"] == null ? null : MetaDataClass.fromJson(json["meta_data"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    feedPrivacy: feedPrivacyValues.map[json["feed_privacy"]]!,
    isBackground: json["is_background"],
    bgColor: json["bg_color"],
    pollId: json["poll_id"],
    lessonId: json["lesson_id"],
    spaceId: json["space_id"],
    videoId: json["video_id"],
    streamId: json["stream_id"],
    blogId: json["blog_id"],
    scheduleDate: json["schedule_date"],
    timezone: json["timezone"],
    isAnonymous: json["is_anonymous"],
    meetingId: json["meeting_id"],
    sellerId: json["seller_id"],
    publishDate: json["publish_date"] == null ? null : DateTime.parse(json["publish_date"]),
    isFeedEdit: json["is_feed_edit"],
    name: json["name"],
    pic: json["pic"],
    uid: json["uid"],
    isPrivateChat: json["is_private_chat"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    group: json["group"],
    poll: json["poll"],
    likeType: json["likeType"] == null ? [] : List<LikeType>.from(json["likeType"]!.map((x) => LikeType.fromJson(x))),
    like: json["like"] == null ? null : Like.fromJson(json["like"]),
    follow: json["follow"],
    savedPosts: json["savedPosts"],
    comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"]!.map((x) => x)),
    meta: json["meta"] == null ? null : PurpleMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "school_id": schoolId,
    "user_id": userId,
    "course_id": courseId,
    "community_id": communityId,
    "group_id": groupId,
    "feed_txt": feedTxt,
    "status": statusValues.reverse[status],
    "slug": slug,
    "title": title,
    "activity_type": activityTypeValues.reverse[activityType],
    "is_pinned": isPinned,
    "file_type": fileTypeValues.reverse[fileType],
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
    "like_count": likeCount,
    "comment_count": commentCount,
    "share_count": shareCount,
    "share_id": shareId,
    "meta_data": metaData?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "feed_privacy": feedPrivacyValues.reverse[feedPrivacy],
    "is_background": isBackground,
    "bg_color": bgColor,
    "poll_id": pollId,
    "lesson_id": lessonId,
    "space_id": spaceId,
    "video_id": videoId,
    "stream_id": streamId,
    "blog_id": blogId,
    "schedule_date": scheduleDate,
    "timezone": timezone,
    "is_anonymous": isAnonymous,
    "meeting_id": meetingId,
    "seller_id": sellerId,
    "publish_date": publishDate?.toIso8601String(),
    "is_feed_edit": isFeedEdit,
    "name": name,
    "pic": pic,
    "uid": uid,
    "is_private_chat": isPrivateChat,
    "user": user?.toJson(),
    "group": group,
    "poll": poll,
    "likeType": likeType == null ? [] : List<dynamic>.from(likeType!.map((x) => x.toJson())),
    "like": like?.toJson(),
    "follow": follow,
    "savedPosts": savedPosts,
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
    "meta": meta?.toJson(),
  };
}

enum ActivityType {
  GROUP
}

final activityTypeValues = EnumValues({
  "group": ActivityType.GROUP
});

enum FeedPrivacy {
  PUBLIC
}

final feedPrivacyValues = EnumValues({
  "Public": FeedPrivacy.PUBLIC
});

enum FileType {
  TEXT
}

final fileTypeValues = EnumValues({
  "text": FileType.TEXT
});

class Like {
  int? id;
  int? feedId;
  int? userId;
  String? reactionType;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isAnonymous;
  MetaDataClass? meta;

  Like({
    this.id,
    this.feedId,
    this.userId,
    this.reactionType,
    this.createdAt,
    this.updatedAt,
    this.isAnonymous,
    this.meta,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    id: json["id"],
    feedId: json["feed_id"],
    userId: json["user_id"],
    reactionType: json["reaction_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isAnonymous: json["is_anonymous"],
    meta: json["meta"] == null ? null : MetaDataClass.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "feed_id": feedId,
    "user_id": userId,
    "reaction_type": reactionType,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_anonymous": isAnonymous,
    "meta": meta?.toJson(),
  };
}

class MetaDataClass {
  MetaDataClass();

  factory MetaDataClass.fromJson(Map<String, dynamic> json) => MetaDataClass(
  );

  Map<String, dynamic> toJson() => {
  };
}

class LikeType {
  String? reactionType;
  int? feedId;
  MetaDataClass? meta;

  LikeType({
    this.reactionType,
    this.feedId,
    this.meta,
  });

  factory LikeType.fromJson(Map<String, dynamic> json) => LikeType(
    reactionType: json["reaction_type"],
    feedId: json["feed_id"],
    meta: json["meta"] == null ? null : MetaDataClass.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "reaction_type": reactionType,
    "feed_id": feedId,
    "meta": meta?.toJson(),
  };
}

class PurpleMeta {
  int? views;

  PurpleMeta({
    this.views,
  });

  factory PurpleMeta.fromJson(Map<String, dynamic> json) => PurpleMeta(
    views: json["views"],
  );

  Map<String, dynamic> toJson() => {
    "views": views,
  };
}

enum Status {
  APPROVED
}

final statusValues = EnumValues({
  "APPROVED": Status.APPROVED
});

class User {
  int? id;
  String? fullName;
  String? profilePic;
  int? isPrivateChat;
  dynamic expireDate;
  String? status;
  dynamic pauseDate;
  UserType? userType;
  MetaDataClass? meta;

  User({
    this.id,
    this.fullName,
    this.profilePic,
    this.isPrivateChat,
    this.expireDate,
    this.status,
    this.pauseDate,
    this.userType,
    this.meta,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    profilePic: json["profile_pic"],
    isPrivateChat: json["is_private_chat"],
    expireDate: json["expire_date"],
    status: json["status"],
    pauseDate: json["pause_date"],
    userType: userTypeValues.map[json["user_type"]]!,
    meta: json["meta"] == null ? null : MetaDataClass.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "profile_pic": profilePic,
    "is_private_chat": isPrivateChat,
    "expire_date": expireDate,
    "status": status,
    "pause_date": pauseDate,
    "user_type": userTypeValues.reverse[userType],
    "meta": meta?.toJson(),
  };
}

enum UserType {
  SITE_OWNER,
  STUDENT
}

final userTypeValues = EnumValues({
  "SITE_OWNER": UserType.SITE_OWNER,
  "STUDENT": UserType.STUDENT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
