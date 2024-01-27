class NotificationModel {
  String type;
  Map<String, dynamic> content;

  NotificationModel(this.type, this.content);
  NotificationModel.fromJson(dynamic json)
      : this(json["type"], json["content"]);

  Map<String, dynamic> toJson() {
    return {'type': type, 'content': content};
  }
}
