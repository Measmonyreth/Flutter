import 'package:ecommerce_flutter/app/data/model/Response/CloneCard.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/Response/Payment.rest.model.dart';
import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:ecommerce_flutter/app/modules/cart/controllers/cart_controller.dart';
import 'package:ecommerce_flutter/app/modules/widget/checkoutdialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_flutter/app/modules/cart/views/cart_view.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController
  final _apiProvider = Get.find<APIProvider>();
  RxBool isLoading = false.obs;
  Rx<CloneCardResponse> cloneCard = CloneCardResponse().obs;
  Rx<PaymentResponse> payment = PaymentResponse().obs;
  var tax = 0.3;

  final CartController cartController = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    // hot reload getcart
  }

  Future<void> getCard({
    required String cvv,
    required String cardNumber,
    required String cardHolderName,
    required String expirationDate,
    String? type,
  }) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getCloneCard(
        cvv: cvv,
        cardNumber: cardNumber,
        cardHolderName: cardHolderName,
        expirationDate: expirationDate,
        type: type,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Treat any 2xx response as success
        try {
          Map<String, dynamic> data = Map<String, dynamic>.from(
            response.data ?? {},
          );
          cloneCard.value = CloneCardResponse.fromJson(data);
        } catch (e) {
          // Log but don't fail if parsing fails
          print('getCard: failed to parse response data: ${response.data}');
        }
      } else {
        // Try to extract a useful error message from response body (validation errors etc.)
        String errorMsg = response.statusMessage ?? 'Unknown error';
        try {
          final respData = response.data;
          if (respData != null) {
            if (respData is Map<String, dynamic>) {
              if (respData['message'] != null) {
                errorMsg = respData['message'].toString();
              } else if (respData['errors'] != null) {
                final errs = respData['errors'];
                if (errs is Map) {
                  errorMsg = errs.entries
                      .map(
                        (e) =>
                            '${e.key}: ${(e.value is List) ? (e.value as List).join(', ') : e.value}',
                      )
                      .join('\n');
                } else if (errs is List) {
                  errorMsg = errs.join(', ');
                } else {
                  errorMsg = errs.toString();
                }
              } else {
                errorMsg = respData.toString();
              }
            } else {
              errorMsg = respData.toString();
            }
          }
        } catch (e) {
          // ignore parsing errors and keep statusMessage
        }

        Get.defaultDialog(title: "Error", content: Text(errorMsg));
      }
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPayment({
    required int cartId,
    required double amount,
    required String paymentMethod,
    num? task,
  }) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.createPayment(
        cartId: cartId,
        amount: amount,
        paymentMethod: paymentMethod,
        task: task,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        try {
          Map<String, dynamic> data = Map<String, dynamic>.from(
            response.data ?? {},
          );
          payment.value = PaymentResponse.fromJson(data);
          await cartController.fetchCart(); // Refresh cart after payment
        } catch (e) {
          print(
            'createPayment: failed to parse response data: ${response.data}',
          );
        }
        // Prefer using the app's `CheckOutDialog` widget if we have a context
        final ctx = Get.overlayContext ?? Get.context;
        if (ctx != null) {
          CheckOutDialog.show(
            ctx,
            title: 'Payment Successful',
            message: 'Payment created successfully.',
            onPressed: () {
              // Called after the dialog is popped
              try {
                Get.back();
                Get.back();
              } catch (_) {}
            },
          );
        } else {
          Get.defaultDialog(
            title: "Success",
            middleText: "Payment created successfully",
            textConfirm: 'OK',
            onConfirm: () {
              // Close dialog then pop the checkout screen
              Get.back();
              try {
                Get.back();
              } catch (_) {}
            },
          );
        }
        print('Payment creation response: ${response.data}');
        // Handle payment creation success
      } else {
        String errorMsg = response.statusMessage ?? 'Unknown error';
        try {
          final respData = response.data;
          if (respData != null) {
            if (respData is Map<String, dynamic>) {
              if (respData['message'] != null) {
                errorMsg = respData['message'].toString();
              } else if (respData['errors'] != null) {
                final errs = respData['errors'];
                if (errs is Map) {
                  errorMsg = errs.entries
                      .map(
                        (e) =>
                            '${e.key}: ${(e.value is List) ? (e.value as List).join(', ') : e.value}',
                      )
                      .join('\n');
                } else if (errs is List) {
                  errorMsg = errs.join(', ');
                } else {
                  errorMsg = errs.toString();
                }
              } else {
                errorMsg = respData.toString();
              }
            } else {
              errorMsg = respData.toString();
            }
          }
        } catch (e) {
          // ignore
        }

        Get.defaultDialog(title: "Error", content: Text(errorMsg));
        // Handle payment creation failure
      }
    } catch (e) {
      Get.defaultDialog(title: "Error_p", content: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
