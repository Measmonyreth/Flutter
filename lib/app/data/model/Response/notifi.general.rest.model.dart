class NotificationGeneralResponse {
  List<Notifications>? notifications;

  NotificationGeneralResponse({this.notifications});

  NotificationGeneralResponse.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] = this.notifications!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class Notifications {
  int? id;
  String? title;
  String? body;
  String? smallImage;
  Null? largeImage;
  String? route;
  String? type;
  String? createdAt;
  String? updatedAt;

  Notifications({
    this.id,
    this.title,
    this.body,
    this.smallImage,
    this.largeImage,
    this.route,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    smallImage = json['small_image'];
    largeImage = json['large_image'];
    route = json['route'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['small_image'] = this.smallImage;
    data['large_image'] = this.largeImage;
    data['route'] = this.route;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
