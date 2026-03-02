import 'dart:convert';

import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:ecommerce_flutter/app/modules/services/storage_service.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  final _provider = Get.find<APIProvider>();
  final RxBool isLoading = false.obs;

  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final response = await _provider.login(email: email, password: password);
      if (response.statusCode == 200) {
        final token = response.data['token'];
        StorageService.write(key: 'token', value: token);
        Map<String, dynamic> user = response.data['user'];
        StorageService.write(key: 'user', value: jsonEncode(user));

        print('token: $token');
        Get.offNamed(Routes.MAIN);
      } else {
        Get.defaultDialog(title: "Error", content: Text("Failed to login"));
      }
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() {
    Get.snackbar(
      'Info',
      'Google sign-in not implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signInWithApple() {
    Get.snackbar(
      'Info',
      'Apple sign-in not implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
