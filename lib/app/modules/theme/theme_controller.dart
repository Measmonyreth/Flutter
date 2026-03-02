import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/app/constant/theme.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
  }
}
