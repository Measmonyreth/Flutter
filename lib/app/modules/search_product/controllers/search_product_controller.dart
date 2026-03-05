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
    super.onInit();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    await getTextSearch(showError: false);
  }

  Future<void> refreshSearchHistory() async {
    await getTextSearch(showError: true);
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
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      // Check if response has data (regardless of status code)
      if (response.data != null) {
        List<dynamic> data = response.data is List ? response.data : [];
        print("Data: $data");
        if (data.isNotEmpty) {
          products.value = data.map((json) => Products.fromJson(json)).toList();
        } else {
          products.value = [];
        }
      }
    } on DioException catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTextSearch({bool showError = true}) async {
    try {
      isSearchLoading.value = true;
      final response = await _provider.getTextSearch();
      print("Search History Status: ${response.statusCode}");
      print("Search History Data: ${response.data}");
      
      if (response.data != null) {
        try {
          Map<String, dynamic> data = response.data is Map ? Map<String, dynamic>.from(response.data) : {};
          searchResults.value = TextSearchResponse.fromJson(data);
        } catch (parseError) {
          print("Error parsing search history: $parseError");
          if (showError) {
            Get.snackbar('Error', 'Failed to parse search results');
          }
        }
      } else {
        if (showError) {
          Get.snackbar('Not Found', 'No search results found');
        }
      }
    } catch (e) {
      print("Search History Exception: $e");
      if (showError) {
        Get.snackbar('Error', e.toString());
      }
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<void> searchProductsByText({
    required String search,
    bool showError = false,
  }) async {
    try {
      searchLoading.value = true;
      final response = await _provider.createTextSearch(searchTerm: search);
      print("Save Search Status: ${response.statusCode}");
      print("Save Search Response: ${response.data}");
      
      // Consider any status code < 400 as success
      if (response.statusCode != null && response.statusCode! < 400) {
        print("Search term saved successfully: $search");
      } else {
        if (showError) {
          Get.snackbar('Error', 'Failed to save search term');
        }
      }
    } catch (e) {
      print("Save Search Error: $e");
      if (showError) {
        Get.snackbar('Error', e.toString());
      }
    } finally {
      searchLoading.value = false;
    }
  }
}
