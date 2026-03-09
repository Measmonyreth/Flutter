class NotificationGeneralResponse {
  List<Notifications>? notifications;
  int? count;

  NotificationGeneralResponse({this.notifications, this.count});

  NotificationGeneralResponse.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] = this.notifications!
          .map((v) => v.toJson())
          .toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Notifications {
  int? id;
  String? title;
  String? body;
  String? largeImage;
  String? bigImage;
  String? route;
  String? type;
  String? createdAt;
  String? updatedAt;

  Notifications({
    this.id,
    this.title,
    this.body,
    this.largeImage,
    this.bigImage,
    this.route,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    largeImage = json['large_image'];
    bigImage = json['big_image'];
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
    data['large_image'] = this.largeImage;
    data['big_image'] = this.bigImage;
    data['route'] = this.route;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
