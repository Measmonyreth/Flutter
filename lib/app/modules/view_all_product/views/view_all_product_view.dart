import 'package:ecommerce_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:ecommerce_flutter/app/modules/view_all_product/controllers/view_all_product_controller.dart';
import 'package:ecommerce_flutter/app/modules/widget/List_cartProduct.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllProductView extends StatefulWidget {
  const ViewAllProductView({super.key});

  @override
  State<ViewAllProductView> createState() => _ViewAllProductViewState();
}

class _ViewAllProductViewState extends State<ViewAllProductView> {
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View All Product')),
      body: Obx(
        () =>
            homeController.isLoading.value &&
                homeController.productsByCategory.length == 0
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: homeController.productsByCategory.length ?? 0,
                itemBuilder: (context, index) {
                  final product = homeController.productsByCategory[index];
                  return CartProductCard(product: product);
                },
              ),
      ),
    );
  }
}
