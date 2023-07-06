// To parse this JSON data, do
//
//     final deleteItemComment = deleteItemCommentFromJson(jsonString);

import 'dart:convert';

DeleteItemComment deleteItemCommentFromJson(String str) =>
    DeleteItemComment.fromJson(json.decode(str));

String deleteItemCommentToJson(DeleteItemComment data) =>
    json.encode(data.toJson());

class DeleteItemComment {
  DeleteItemComment({
    this.comment,
    this.message,
  });

  final Comment comment;
  final Message message;

  factory DeleteItemComment.fromJson(Map<String, dynamic> json) =>
      DeleteItemComment(
        comment: Comment.fromJson(json["Comment"]),
        message: Message.fromJson(json["Message"]),
      );

  Map<String, dynamic> toJson() => {
        "Comment": comment.toJson(),
        "Message": message.toJson(),
      };
}

class Comment {
  Comment({
    this.id,
    this.description,
    this.deleted,
  });

  final int id;
  final String description;
  final bool deleted;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["ID"],
        description: json["Description"],
        deleted: json["Deleted"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Description": description,
        "Deleted": deleted,
      };
}

class Message {
  Message({
    this.data,
    this.items,
    this.action,
    this.isRejected,
    this.isAlerted,
    this.isApproved,
    this.count,
    this.redirect,
  });

  final Data data;
  final Data items;
  final int action;
  final bool isRejected;
  final bool isAlerted;
  final bool isApproved;
  final int count;
  final dynamic redirect;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        data: Data.fromJson(json["Data"]),
        items: Data.fromJson(json["Items"]),
        action: json["Action"],
        isRejected: json["IsRejected"],
        isAlerted: json["IsAlerted"],
        isApproved: json["IsApproved"],
        count: json["Count"],
        redirect: json["Redirect"],
      );

  Map<String, dynamic> toJson() => {
        "Data": data.toJson(),
        "Items": items.toJson(),
        "Action": action,
        "IsRejected": isRejected,
        "IsAlerted": isAlerted,
        "IsApproved": isApproved,
        "Count": count,
        "Redirect": redirect,
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
