import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:ecommerce_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:ecommerce_flutter/app/modules/widget/product_cart.dart';
import 'package:get/get.dart';
import 'package:ecommerce_flutter/app/modules/theme/theme_controller.dart';

class APIBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(APIProvider(), permanent: true);
    Get.put(ThemeController(), permanent: true);
  }
}
