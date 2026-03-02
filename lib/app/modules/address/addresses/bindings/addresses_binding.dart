import 'package:ecommerce_flutter/app/modules/address/addresses/controllers/addresses_controller.dart';
import 'package:get/get.dart';


class AddressesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressesController>(
      () => AddressesController(),
    );
  }
}
