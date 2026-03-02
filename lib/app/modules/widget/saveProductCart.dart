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
            return Slidable(
              key: ValueKey(product.id),

              // ✅ End slide (right → left) = Unsave
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      await homecontroller.toggleSaveProduct(
                        productId: product.id!,
                        currentlySaved: isSaved,
                      );
                      controller.savedProductsList.value.removeWhere(
                        (p) => p.id == product.id,
                      );
                      controller.savedProductsList.refresh();
                    },
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    icon: Icons.favorite_border,
                    label: 'Unsave',
                  ),
                ],
              ),

              child: GestureDetector(
                onTap: () => Get.to(
                  () => ProductDetailView(product: product),
                  binding: HomeBinding(),
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
