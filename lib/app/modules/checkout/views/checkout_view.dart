import 'package:ecommerce_flutter/app/modules/cart/controllers/cart_controller.dart';
import 'package:ecommerce_flutter/app/modules/widget/checkoutdialog.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  CheckoutView({super.key});
  // num get total => controller.cloneCard.value.data != null
  //     ? double.parse(controller.cloneCard.value.data!.amount ?? '0') +
  //           double.parse(controller.cloneCard.value.data!.amount ?? '0') *
  //               controller.tax
  //     : 0.0;
  num get total {
    // Prefer cart total if available, otherwise fall back to cloneCard amount
    final cartController = Get.find<CartController>();
    final cartTotal = cartController.cart.value.total ?? 0.0;
    final cloneAmount =
        double.tryParse(controller.cloneCard.value.data?.amount ?? '') ?? 0.0;
    final base = (cartTotal > 0) ? cartTotal : cloneAmount;
    return base + base * controller.tax;
  }

  @override
  Widget build(BuildContext context) {
    late CartController cartController = Get.find<CartController>();
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController cardHolderController = TextEditingController();
    final TextEditingController expirationDateController =
        TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    if (!Get.isRegistered<CartController>()) {
      cartController = Get.put<CartController>(CartController());
    } else {
      cartController = Get.find<CartController>();
    }

    RxInt _selectedCard = 0.obs; // 0 = MasterCard, 1 = VISA

    final user = cartController.cart.value;
    final clonecard = controller.cloneCard.value;
    return Obx(() {
      if (cartController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Payment',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (cartController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = cartController.cart.value;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order summery', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Order:"),
                              Spacer(),
                              Text("${user.total} \$" ?? 'N/A'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text("Tax:"),
                              Spacer(),
                              Text("${controller.tax} \$"),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text("Total:"),
                              Spacer(),
                              Text("${total} \$" ?? 'N/A'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  'Payment methods',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // MasterCard
                GestureDetector(
                  onTap: () {
                    _selectedCard.value = 0;
                    controller.getCard(
                      cvv: cvvController.text,
                      cardNumber: cardNumberController.text,
                      cardHolderName: cardHolderController.text,
                      expirationDate: expirationDateController.text,
                      type: "master_card",
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedCard.value == 0
                            ? Colors.orange
                            : Colors.grey[200]!,
                        width: _selectedCard.value == 0 ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Card Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.credit_card,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Card Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MasterCard',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Credit card',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Card Number
                        Text(
                          // get card number from cloneCard or get text from cardNumberController
                          controller.cloneCard.value.data?.cardNumber != null
                              ? '**** **** **** ${controller.cloneCard.value.data!.cardNumber!.substring(controller.cloneCard.value.data!.cardNumber!.length - 4)}'
                              : cardNumberController.text.isNotEmpty
                              ? '**** **** **** ${cardNumberController.text.substring(cardNumberController.text.length - 4)}'
                              : '**** **** **** 1234',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),

                        // Radio Button
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedCard.value == 0
                                  ? Colors.orange
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: _selectedCard.value == 0
                              ? Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedCard.value == 0)
                  // field input such as card number, card holder name, expiration date, CVV for MasterCard
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          border: OutlineInputBorder(),
                        ),
                        controller: cardNumberController,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Card Holder Name',
                          border: OutlineInputBorder(),
                        ),
                        controller: cardHolderController,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: expirationDateController,
                              decoration: InputDecoration(
                                labelText: 'Expiration Date',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: cvvController,
                              decoration: InputDecoration(
                                labelText: 'CVV',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Container(), // empty container when VISA is selected
                // VISA
                GestureDetector(
                  onTap: () {
                    _selectedCard.value = 1;
                    controller.getCard(
                      cvv: cvvController.text,
                      cardNumber: cardNumberController.text,
                      cardHolderName: cardHolderController.text,
                      expirationDate: expirationDateController.text,
                      type: "visa",
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedCard.value == 1
                            ? Colors.blue
                            : Colors.grey[200]!,
                        width: _selectedCard.value == 1 ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Card Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.credit_card,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Card Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'VISA',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Debit card',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Card Number
                        const Text(
                          '3566******0505',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),

                        // Radio Button
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedCard.value == 1
                                  ? Colors.blue
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: _selectedCard.value == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_selectedCard.value == 1)
                  // field input such as card number, card holder name, expiration date, CVV for MasterCard
                  Column(
                    children: [
                      TextField(
                        controller: cardNumberController,
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: cardHolderController,
                        decoration: InputDecoration(
                          labelText: 'Card Holder Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: expirationDateController,
                              decoration: InputDecoration(
                                labelText: 'Expiration Date',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: cvvController,
                              decoration: InputDecoration(
                                labelText: 'CVV',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Container(),

                const SizedBox(height: 16),

                // Save card details checkbox
                GestureDetector(
                  onTap: () {
                    // Just for UI demonstration
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _selectedCard.value == 0
                              ? Colors.orange
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Save card details for future payments',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Obx(() {
                  return ElevatedButton(
                    onPressed: () {
                      // Just for UI demonstration
                      final parsedAmount = double.tryParse(
                        controller.cloneCard.value.data?.amount ?? '',
                      );
                      final amountToUse = parsedAmount ?? (user.total ?? 0.0);
                      controller.createPayment(
                        cartId: user.carts?.id ?? 0,
                        amount: amountToUse,
                        paymentMethod: _selectedCard.value == 0
                            ? 'master_card'
                            : 'visa',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedCard.value == 0
                          ? Colors.orange
                          : Colors.blue, // Match selected card color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      maximumSize: const Size(double.infinity, 50),
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      );
    });
  }
}
