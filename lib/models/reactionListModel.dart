// To parse this JSON data, do
//
//     final reactionListModel = reactionListModelFromJson(jsonString);

import 'dart:convert';

List<ReactionListModel> reactionListModelFromJson(String str) => List<ReactionListModel>.from(json.decode(str).map((x) => ReactionListModel.fromJson(x)));

String reactionListModelToJson(List<ReactionListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReactionListModel {
  int? totalLikes;
  String? reactionType;
  Meta? meta;

  ReactionListModel({
    this.totalLikes,
    this.reactionType,
    this.meta,
  });

  factory ReactionListModel.fromJson(Map<String, dynamic> json) => ReactionListModel(
    totalLikes: json["total_likes"],
    reactionType: json["reaction_type"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "total_likes": totalLikes,
    "reaction_type": reactionType,
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
