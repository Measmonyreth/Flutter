import 'package:dio/dio.dart';
import 'package:ecommerce_flutter/app/data/model/Response/textsearch.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/product.rest.model.dart';
import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:get/get.dart';

class SearchProductController extends GetxController {
  //TODO: Implement SearchProductController

  final _provider = Get.find<APIProvider>();
  var products = <Products>[].obs;
  var isLoading = false.obs;
  RxBool isSearchLoading = false.obs; // loading state for text search

  RxBool hasSearched = false.obs; // loading state for text search
  Rx<TextSearchResponse> searchResults = TextSearchResponse().obs;
  RxBool searchLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    // searchProduct();
    super.onInit();
    getTextSearch();
  }

  void searchProduct({
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      isLoading.value = true;
      hasSearched.value = true;
      final response = await _provider.searchProduct(
        search: search,
        maxPrice: maxPrice,
        minPrice: minPrice,
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print("Data: $data");
        if (data.isNotEmpty) {
          products.value = data.map((json) => Products.fromJson(json)).toList();
        } else {
          products.value = [];
        }
      } else {
        Get.snackbar('Error', 'Failed to load products');
      }
    } on DioException catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTextSearch() async {
    try {
      isSearchLoading.value = true;
      final response = await _provider.getTextSearch();
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        searchResults.value = TextSearchResponse.fromJson(data);
      } else {
        Get.snackbar('Error', 'Failed to load search results');
      }
      print(response.statusCode);
      print(response.data);
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchProductsByText({required String search}) async {
    try {
      searchLoading.value = true;
      final response = await _provider.createTextSearch(searchTerm: search);
      if (response.statusCode == 200) {
        // List<dynamic> data = response.data;
        // products.value = data.map((json) => Products.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load products');
      }
      print(response.statusCode);
      print(response.data);
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    } finally {
      searchLoading.value = false;
    }
  }
}
