import 'package:ecommerce_flutter/app/modules/widget/detailnotification.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ecommerce_flutter/app/constant/constant.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final NotificationController controller;
  //final controller = Get.put(NotificationController());
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    Get.delete<NotificationController>(force: true);
    controller = Get.put(NotificationController());
  }

  @override
  void dispose() {
    Get.delete<NotificationController>(force: true); // ✅ Clean up when leaving
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      _isInitialized = true;
      controller.loadInitialData(); // ✅ runs only once
    }
    return Scaffold(
      appBar: AppBar(title: const Text('NotificationView'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () => controller.loadInitialData(),
        child: Obx(() {
          if (controller.isLoading.value)
            return const Center(child: CircularProgressIndicator());
          // set duration for get

          final notifications =
              controller.notificationGeneralResponse.value.notifications;
          final seenList =
              controller.notificationSeenUnseenResponse.value.notifications;

          // ✅ Wait until seen list is also loaded (not null)
          if (notifications == null || notifications.isEmpty) {
            return const Center(child: Text("No notifications available"));
          }
          return ListView.builder(
            itemCount: controller
                .notificationGeneralResponse
                .value
                .notifications!
                .length,
            itemBuilder: (context, index) {
              final notification = controller
                  .notificationGeneralResponse
                  .value
                  .notifications![index];

              final notifiUserSeen =
                  controller.notificationSeenUnseenResponse.value.notifications;
              final isSeen =
                  seenList != null &&
                  seenList.any(
                    (seen) => seen.notificationGeneralId == notification.id,
                  );

              print(
                'isSeen=$isSeen, notifi_user_seen length=${notifiUserSeen?.length ?? 0}',
              );
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSeen
                        ? Colors.transparent
                        : Colors.blue.withOpacity(0.05), // subtle bg for unseen
                    border: Border.all(
                      color: isSeen ? Colors.transparent : Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    leading: notification.largeImage != null
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              //  "${kBaseURL}${notification.smallImage}",
                              "${notification.largeImage}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print("Image load error: $error");
                                return Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 24,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.notifications, size: 24),
                          ),
                    title: Text(
                      notification.title ?? "No Title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      notification.body ?? "No Body",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      // ✅ Mark as read
                      await controller.markNotificationAsRead(
                        notificationId: notification.id ?? 0,
                      );
                      // ✅ Navigate and wait for return
                      await Get.to(
                        () => NotificationDetailPage(controller: notification),
                      );
                      // ✅ Refresh seen status after coming back
                      await controller.getNotificationUserSeen();
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
