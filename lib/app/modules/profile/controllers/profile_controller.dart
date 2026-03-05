import 'package:ecommerce_flutter/app/data/model/Response/save.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/Response/user.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/product.rest.model.dart';
import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  final _apiProvider = Get.find<APIProvider>();
  final RxBool isLoading = true.obs;
  Rx<UserResponse> userProfile = UserResponse().obs;
  Rx<SaveResponse> savedProducts = SaveResponse().obs;
  RxList<Products> savedProductsList = <Products>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile(showError: false);
    getSavedProducts(showError: false);
  }

  Future<void> fetchProfile({bool showError = true}) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getProfile();
      if (response.statusCode == 200) {
        // response.data contains the top-level map { "user": { ... } }
        // UserReserponse.fromJson expects that top-level map, so pass it directly.
        Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        userProfile.value = UserResponse.fromJson(data);
      } else {
        if (showError) {
          Get.defaultDialog(
            title: "Error",
            content: Text("Failed to fetch profile"),
          );
        }
      }
      print(response.statusCode);
      print(response.data);
    } catch (e) {
      if (showError) {
        Get.defaultDialog(title: "Error", content: Text(e.toString()));
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.logout();
      if (response.statusCode == 200) {
        // Clear any stored user data or tokens here if needed
        Get.offAllNamed('/login'); // Navigate to login screen
      } else {
        Get.defaultDialog(title: "Error", content: Text("Failed to logout"));
      }
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSavedProducts({bool showError = true}) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getSavedProducts();
      if (response.statusCode == 200) {
        Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        // savedProducts.value = SaveResponse.fromJson(data);
        savedProductsList
            .value = (data['saved_products'] as List<dynamic>).map((e) {
          if (e is Map<String, dynamic>) {
            // API may return saved product wrapper containing a nested `product` map
            final productJson = e['product'] is Map<String, dynamic>
                ? Map<String, dynamic>.from(e['product'])
                : Map<String, dynamic>.from(e);
            return Products.fromJson(productJson);
          }
          return Products();
        }).toList();
        // Handle the saved products data as needed
        print("Saved products: ${response.data}");
        print('Count: ${savedProductsList.value.length}');
      } else {
        if (showError) {
          Get.defaultDialog(
            title: "Error",
            content: Text("Failed to fetch saved products"),
          );
        }
      }
    } catch (e) {
      if (showError) {
        Get.defaultDialog(title: "Error", content: Text(e.toString()));
      }
    } finally {
      isLoading.value = false;
    }
  }
}
