import 'package:ecommerce_flutter/app/data/model/Response/category.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/Response/save.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/product.rest.model.dart';
import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final _apiProvider = Get.find<APIProvider>();

  RxBool isLoading = true.obs;
  Rx<Product> products = Product().obs;
  Rx<CategoryResponse> categories = CategoryResponse().obs;
  RxList<Products> productsByCategory = <Products>[].obs;
  RxList<SavedProducts> savedProductsList = <SavedProducts>[].obs;
  RxMap<int, bool> savedStatusMap = <int, bool>{}.obs;
  RxSet<int> loadingProducts = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
    fetchSavedProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getProducts();
      products.value = Product.fromJson(response.data);
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSavedProducts() async {
    try {
      final response = await _apiProvider.getSavedProducts();
      if (response.statusCode == 200) {
        final data = SaveResponse.fromJson(
          Map<String, dynamic>.from(response.data),
        );

        savedProductsList.value = data.savedProducts ?? [];
        initializeSavedStatus();
      }
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    }
  }

  Future<void> saveProducts({required int productId}) async {
    try {
      loadingProducts.add(productId);
      final response = await _apiProvider.saveProduct(productId: productId);

      print('=== SAVE RESPONSE ===');
      print('statusCode: ${response.statusCode}');
      print('data: ${response.data}');

      // if (response.statusCode == 201) {
      //   print('before: ${savedStatusMap[productId]}');
      //   savedStatusMap[productId] = true;
      //   savedStatusMap.refresh();
      //   print('after: ${savedStatusMap[productId]}');
      // }
      if (response.statusCode == 200 || response.statusCode == 201) {
        savedStatusMap[productId] = true;
        savedStatusMap.refresh();
      }
    } catch (e) {
      print('=== SAVE ERROR ===');
      print(e.toString());
    } finally {
      loadingProducts.remove(productId);
    }
  }

  Future<void> clearSavedProducts({required int productId}) async {
    try {
      loadingProducts.add(productId);
      final response = await _apiProvider.clearSavedProducts(
        productId: productId,
      );

      print('=== UNSAVE RESPONSE ===');
      print('statusCode: ${response.statusCode}');
      print('data: ${response.data}');

      if (response.statusCode == 200) {
        print('before: ${savedStatusMap[productId]}');
        savedStatusMap[productId] = false;
        savedStatusMap.refresh();
        print('after: ${savedStatusMap[productId]}');
      }
    } catch (e) {
      print('=== UNSAVE ERROR ===');
      print(e.toString());
    } finally {
      loadingProducts.remove(productId);
    }
  }

  // Add a method to toggle save/unsave
  Future<void> toggleSaveProduct({
    required int productId,
    required bool currentlySaved,
  }) async {
    if (currentlySaved) {
      await clearSavedProducts(productId: productId);
    } else {
      await saveProducts(productId: productId);
    }
  }

  // Method to check if a product is saved
  bool isProductSaved(int productId) {
    return savedStatusMap[productId] ?? false;
  }

  // Method to initialize saved status from savedProductsList
  void initializeSavedStatus() {
    savedStatusMap.clear();
    for (var savedProduct in savedProductsList) {
      // ✅ Check status == 'active' not just exists
      savedStatusMap[savedProduct.productId!] = savedProduct.status == 'active';
      savedStatusMap.refresh();
    }
  }

  Future<void> addtoCart({
    required int productId,
    required int quantity,
    required num price,
  }) async {
    try {
      final response = await _apiProvider.addToCart(
        productId: productId,
        quantity: quantity,
        price: price,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Product added to cart");
      } else {
        Get.snackbar("Error", "Failed to add product to cart");
      }

      print(response.statusCode);
      print(response.data);
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getCategories();
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        categories.value = CategoryResponse.fromJson(data);
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text("Failed to fetch categories"),
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

  Future<void> getProductsByCategory({
    required int cateId,
    required int pageNum,
  }) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getProductByCate(
        cartId: cateId,
        pageNum: pageNum,
      );
      if (response.statusCode == 200) {
        // make product to list of products
        List<dynamic> data = response.data['data'];
        productsByCategory.value = data
            .map((json) => Products.fromJson(json))
            .toList();

        // Some API responses are paginated and return the products list
        // under `data` (e.g. {current_page:..., data: [...]}) while
        // other endpoints may return a category object with `products`.
        // if (response.data is Map && response.data['data'] != null && response.data['data'] is List) {
        //   final list = (response.data['data'] as List)
        //       .map((json) => Products.fromJson(json as Map<String, dynamic>))
        //       .toList();
        //   productsByCategory.value = Categories(
        //     id: response.data['id'] as int?,
        //     name: response.data['name'] as String?,
        //     products: list,
        //   );
        // } else {
        //   productsByCategory.value = Categories.fromJson(response.data);
        // }
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text("Failed to fetch products by category"),
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
}
