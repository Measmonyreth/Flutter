import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ecommerce_flutter/app/constant/constant.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NotificationView'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.notificationGeneralResponse.value.notifications ==
                null ||
            controller
                .notificationGeneralResponse
                .value
                .notifications!
                .isEmpty) {
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
            return ListTile(
              leading: notification.smallImage != null
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        //  "${kBaseURL}${notification.smallImage}",
                        "${urlImg}${notification.smallImage}",
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
                            child: Icon(Icons.image_not_supported, size: 24),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
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
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
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
              title: Text(notification.title ?? "No Title"),
              subtitle: Text(notification.body ?? "No Body"),
            );
          },
        );
      }),
    );
  }
}
