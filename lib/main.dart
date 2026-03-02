import 'package:ecommerce_flutter/app/global_binding/ApiBinding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_flutter/app/constant/theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      theme: lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: APIBinding(),
    ),
  );
}
