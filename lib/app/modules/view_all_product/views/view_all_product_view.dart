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
  int? categoryId;

  @override
  void initState() {
    super.initState();
    // Read category id from route arguments and fetch products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = Get.arguments;
      if (arg != null) {
        try {
          categoryId = arg is int ? arg : int.tryParse(arg.toString());
        } catch (e) {
          categoryId = null;
        }
      }
      if (categoryId != null) {
        homeController.getProductsByCategory(cateId: categoryId!, pageNum: 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View All Product')),
      body: Obx(() {
        if (homeController.isLoading.value &&
            homeController.productsByCategory.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: homeController.productsByCategory.length,
          itemBuilder: (context, index) {
            final product = homeController.productsByCategory[index];
            return CartProductCard(product: product);
          },
        );
      }),
    );
  }
}
