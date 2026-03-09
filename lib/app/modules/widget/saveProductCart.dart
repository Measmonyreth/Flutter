import 'package:ecommerce_flutter/app/data/model/product.rest.model.dart';
import 'package:ecommerce_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:ecommerce_flutter/app/modules/product-detail/views/product_detail_view.dart';
import 'package:ecommerce_flutter/app/modules/home/bindings/home_binding.dart';
import 'package:ecommerce_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:ecommerce_flutter/app/modules/widget/List_cartProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class SavedProductsView extends StatelessWidget {
  const SavedProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    // Initialize HomeController if not already initialized
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }
    late final HomeController homecontroller = Get.find<HomeController>();

    // ✅ fetch when page opens (defer to after first frame to avoid triggering
    // widget rebuilds during the build phase)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSavedProducts();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Products')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = controller.savedProductsList.value;

        if (products == null || products.isEmpty) {
          return const Center(child: Text('No saved products'));
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products![index];
            final isSaved = homecontroller.savedStatusMap[product.id] ?? false;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Slidable(
                key: ValueKey(product.id),

                // ✅ End slide (right → left) = Unsave
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  extentRatio: 0.25,
                  children: [
                    CustomSlidableAction(
                      onPressed: (context) {
                        homecontroller.toggleSaveProduct(
                          productId: product.id!,
                          currentlySaved: isSaved,
                        );
                        controller.savedProductsList.value.removeWhere(
                          (p) => p.id == product.id,
                        );
                        controller.savedProductsList.refresh();
                      },
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 8,
                          bottom: 12,
                          //top: 8,
                        ), // ← gap from card
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        width: double.infinity,
                        height: double.infinity, // ← matches card height
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Unsaved',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                child: CartProductCard(product: product),
              ),
            );
          },
        );
      }),
    );
  }
}
