import 'package:ecommerce_flutter/app/data/model/cart.rest.model.dart';
import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  //TODO: Implement CartController\
  final _apiProvider = Get.find<APIProvider>();
  RxBool isLoading = true.obs;
  Rx<Cart> cart = Cart().obs;
  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = false;
      final response = await _apiProvider.getCartProducts();
      if (response.statusCode == 200) {
        cart.value = Cart.fromJson(response.data);
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text("Failed to fetch cart products"),
        );
      }
      // print(response.statusCode);
      // print(response.data);
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
