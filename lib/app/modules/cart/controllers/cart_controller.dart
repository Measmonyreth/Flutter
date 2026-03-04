import 'package:ecommerce_flutter/app/data/model/cart.rest.model.dart';
import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  //TODO: Implement CartController\
  final _apiProvider = Get.find<APIProvider>();
  RxBool isLoading = true.obs;
  Rx<Cart> cart = Cart().obs;
  RxInt quantity = 1.obs;

  void increment(Items item) async {
    // Find the item in the cart and update it
    item.quantity = (item.quantity ?? 0) + 1;
    cart.refresh(); // Update UI

    // Call API to update on server
    await updateCartItem(
      productId: item.productId!,
      quantity: item.quantity!,
      price: item.product!.price!,
    );
  }

  void decrement(Items item) {
    // Find the item in the cart and update it
    if (item.quantity != null && item.quantity! > 1) {
      item.quantity = item.quantity! - 1;
      cart.refresh(); // Update UI

      // Call API to update on server
      updateCartItem(
        productId: item.productId!,
        quantity: item.quantity!,
        price: item.product!.price!,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> updateCartItem({
    required int productId,
    required int quantity,
    required num price,
  }) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.updateCart(
        productId: productId,
        quantity: quantity,
        price: price,
      );
      if (response.statusCode == 200) {
        await fetchCart();
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text("Failed to update cart"),
        );
      }
      print(response.statusCode);
      print(response.data);
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getCartProducts();
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          // API returned items list directly (including empty list)
          cart.value = Cart.fromJson({
            'carts': {'items': data},
          });
        } else if (data is Map) {
          cart.value = Cart.fromJson(Map<String, dynamic>.from(data));
        } else {
          Get.defaultDialog(
            title: "Error",
            content: Text("Unexpected cart response format"),
          );
        }
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text("Failed to fetch cart products"),
        );
      }
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart({required int productId}) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.removeFromCart(productId: productId);
      if (response.statusCode == 200) {
        await fetchCart();
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text("Failed to remove product from cart"),
        );
      }
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
