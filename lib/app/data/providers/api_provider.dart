import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce_flutter/app/modules/services/storage_service.dart';

import '../../constant/constant.dart';

class APIProvider {
  /// using dio to talk with API
  ///
  final token = StorageService.read(key: 'token');

  final _dio = Dio(
    BaseOptions(
      baseUrl: kBaseURL,
      contentType: 'application/json',
      responseType: ResponseType.json,
      receiveTimeout: Duration(minutes: 1),
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    File? image,
  }) async {
    try {
      // print("image ${image!.path}");
      final _formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'avatar': image != null
            ? await MultipartFile.fromFile(image.path)
            : null,
      });

      return await _dio.post("/register", data: _formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final _formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      return await _dio.post("/login", data: _formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logout() async {
    try {
      return await _dio.delete(
        "/logout",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updartProfile({
    String? name,
    String? email,
    File? image,
    String? phone,
    String? address,
    String? country,
    String? cityOrprovince,
    String? male,
  }) async {
    try {
      final _formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (country != null) 'country': country,
        if (cityOrprovince != null) 'cityOrProvince': cityOrprovince,
        if (male != null) 'sex': male,
        if (image != null) 'avatar': await MultipartFile.fromFile(image.path),
      });

      return await _dio.post(
        "/user/update",
        data: _formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProducts() async {
    try {
      return await _dio.get("/products");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> searchProduct({
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParameters = {
        if (search != null) 'name': search,
        if (minPrice != null) 'min_price': minPrice.toString(),
        if (maxPrice != null) 'max_price': maxPrice.toString(),
      };

      return await _dio.get(
        '/product-search?search=$search&min_price=${minPrice?.toString()}&max_price=${maxPrice?.toString()}',
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProductByCate({
    required int cartId,
    required int pageNum,
  }) async {
    try {
      print("${_dio.get('/product-cate/${cartId}?page=$pageNum')}");
      return await _dio.get(
        '/product-cate/${cartId}?page=$pageNum',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCartProducts() async {
    try {
      return await _dio.get(
        "/viewCart",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addToCart({
    required int productId,
    required int quantity,
    required num price,
  }) async {
    try {
      return await _dio.post(
        '/cart',
        data: {'product_id': productId, 'quantity': quantity, 'price': price},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateCart({
    required int productId,
    required int quantity,
    required num price,
  }) async {
    try {
      return await _dio.post(
        '/cart/update',
        data: {'product_id': productId, 'quantity': quantity, 'price': price},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> removeFromCart({required int productId}) async {
    try {
      return await _dio.post(
        '/remove-cart-item/$productId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveProduct({productId}) async {
    try {
      return await _dio.post(
        '/save-product',
        data: {'product_id': productId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getSavedProducts() async {
    try {
      return await _dio.get(
        "/saved-products",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> clearSavedProducts({required num productId}) async {
    try {
      return await _dio.post(
        "/unsave-product",
        data: {'product_id': productId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProfile() async {
    try {
      return await _dio.get(
        "/user/get",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCategories() async {
    try {
      return await _dio.get("/categories");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getTextSearch() async {
    try {
      return await _dio.get(
        "/text-searches/user",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createTextSearch({required String searchTerm}) async {
    try {
      return await _dio.post(
        "/text-search",
        data: {'text': searchTerm},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCloneCard({
    required String cvv,
    required String cardNumber,
    required String cardHolderName,
    required String expirationDate,
    String? type,
  }) async {
    try {
      return await _dio.get(
        "/clone-cards",
        data: {
          'cvv': cvv,
          'card_number': cardNumber,
          'cardholder_name': cardHolderName,
          'expiry_date': expirationDate,
          'type': type,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createPayment({
    required int cartId,
    required double amount,
    required String paymentMethod,
    num? task,
  }) async {
    try {
      return await _dio.post(
        "/payment",
        data: {
          'cart_id': cartId,
          'amount': amount,
          'payment_method': paymentMethod,
          'task': task,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
