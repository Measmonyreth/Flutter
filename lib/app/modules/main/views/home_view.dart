import 'package:ecommerce_flutter/app/modules/theme/theme_controller.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class MainView extends GetView<MainController> {
  MainView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: Routes.HOME,
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor:
              theme.bottomNavigationBarTheme.unselectedItemColor,
          currentIndex: controller.currentIndex.value,
          onTap: controller.onTab,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Notifications",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
