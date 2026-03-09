import 'package:ecommerce_flutter/app/data/model/Response/notifi.general.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/Response/notification.rest.model.dart';
import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class NotificationController extends GetxController {
  //TODO: Implement NotificationController

  final _apiProvider = Get.find<APIProvider>();
  Rx<NotificationGeneralResponse> notificationGeneralResponse =
      NotificationGeneralResponse().obs;
  Rx<NotificationSeenUnseenResponse> notificationSeenUnseenResponse =
      NotificationSeenUnseenResponse().obs;

  final RxBool isLoading = false.obs;
  RxInt notificationCount = 0.obs;
  RxInt seenCount = 0.obs;
  RxInt unSeenCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> calculateNotificationCount() async {
    final notifications =
        notificationSeenUnseenResponse.value.notifications ?? [];

    unSeenCount.value = notificationGeneralResponse.value.count ?? 0;

    seenCount.value = notifications.where((n) => n.status == 'read').length;
    notificationCount.value =
        unSeenCount.value - seenCount.value; // badge shows unread only

    print("notificationCount: $notificationCount");
    print("seenCount: $seenCount");
    print("unSeenCount: $unSeenCount");
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;

      // ✅ Run sequentially, not parallel
      await fetchNotifications();
      await getNotificationUserSeen();

      // ✅ Calculate count after data is loaded
      calculateNotificationCount();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getGeneralNotifications();
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        try {
          // API returns {notifications: [...]}
          Map<String, dynamic> data = response.data is Map
              ? Map<String, dynamic>.from(response.data)
              : {};
          notificationGeneralResponse.value =
              NotificationGeneralResponse.fromJson(data);

          // check id of notification and seen

          print(
            'Parsed notifications: ${notificationGeneralResponse.value.notifications}',
          );
          // image url
          for (var notification
              in notificationGeneralResponse.value.notifications ?? []) {
            print('Image URL: ${notification.bigImage}');
          }
        } catch (parseError) {
          print('Error parsing notifications: $parseError');
          Get.defaultDialog(
            title: "Error",
            content: Text("Failed to parse notifications: $parseError"),
          );
        }
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text(
            "Failed to fetch notifications (Status: ${response.statusCode})",
          ),
        );
      }
    } catch (e) {
      print('Fetch Error: $e');
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markNotificationAsRead({required int notificationId}) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.markNotificationAsRead(
        notificationId: notificationId,
      );
      if (response.statusCode == 201) {
        print('Mark Read Response Status: ${response.statusCode}');
        print('Mark Read Response Data: ${response.data}');
      }
    } catch (e) {
      print('Mark Read Error: $e');
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getNotificationUserSeen() async {
    try {
      final response = await _apiProvider.getNotificationUserSeen();
      if (response.statusCode == 200) {
        notificationSeenUnseenResponse.value =
            NotificationSeenUnseenResponse.fromJson(response.data);
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text("response.statusCode: ${response.statusCode}"),
        );
      }
    } catch (e) {
      return print("error ${e.toString()}");
    }
  }
}
