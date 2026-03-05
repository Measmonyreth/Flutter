class NotificationSeenUnseenResponse {
  List<Notifications>? notifications;

  NotificationSeenUnseenResponse({this.notifications});

  NotificationSeenUnseenResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  int? notificationGeneralId;
  String? status;
  String? createdAt;
  String? updatedAt;

  Notifications({
    this.id,
    this.userId,
    this.notificationGeneralId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    notificationGeneralId = json['notification_general_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['notification_general_id'] = this.notificationGeneralId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
