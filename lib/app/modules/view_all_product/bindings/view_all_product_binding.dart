import 'package:get/get.dart';

import '../controllers/view_all_product_controller.dart';

class ViewAllProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewAllProductController>(
      () => ViewAllProductController(),
    );
  }
}
