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
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
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
          Map<String, dynamic> data = response.data is Map ? Map<String, dynamic>.from(response.data) : {};
          notificationGeneralResponse.value = NotificationGeneralResponse.fromJson(data);
          
          print('Parsed notifications: ${notificationGeneralResponse.value.notifications}');
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
          content: Text("Failed to fetch notifications (Status: ${response.statusCode})"),
        );
      }
    } catch (e) {
      print('Fetch Error: $e');
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
