import 'package:ecommerce_flutter/app/global_binding/ApiBinding.dart';
import 'package:ecommerce_flutter/app/util/helper/awesome_notifications_helper.dart';
import 'package:ecommerce_flutter/app/util/helper/fcm_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_flutter/app/constant/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmHelper.initFcm();
  await AwesomeNotificationsHelper.init();
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
