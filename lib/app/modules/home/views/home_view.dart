import 'package:ecommerce_flutter/app/constant/constant.dart';
import 'package:ecommerce_flutter/app/constant/theme.dart';
import 'package:ecommerce_flutter/app/data/model/Response/save.rest.model.dart';
import 'package:ecommerce_flutter/app/modules/widget/carousel.dart';
import 'package:ecommerce_flutter/app/modules/widget/product_cart.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = Theme.of(context);
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.products.value.categories == null
            ? const Center(child: Text("No products available"))
            : RefreshIndicator(
                onRefresh: () async {
                  controller.fetchProducts();
                },
                child: CustomScrollView(
                  slivers: [
                    // show profile using circle avatar with hello and name below it
                    // add notification icon on the right side of the app bar
                    SliverAppBar(
                      // leading: Padding(
                      //   padding: const EdgeInsets.only(left: 10.0),
                      //   // Add padding if necessary
                      //   child: CircleAvatar(
                      //     radius: 15,
                      //     backgroundImage: NetworkImage(kNoImageUrl),
                      //   ),
                      // ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Wellcom",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            "to our store",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          alignment: Alignment.center,
                          // padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: IconButton(
                            onPressed: () {
                              Get.toNamed('/cart');
                            },
                            icon: Icon(
                              Icons.notifications,
                              size: 30,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                      // expandedHeight: ,
                      centerTitle: false,
                      // Adjust as needed for your layout
                      floating: true,
                    ),

                    // Category banner section
                    if (controller.categories.isNotEmpty &&
                        controller.isLoading.value == false)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          child: Container(
                            height: Get.height * 0.1,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.categories.length,
                              itemBuilder: (context, index) {
                                final category = controller.categories[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: Get.width * 0.15,
                                        //  margin: const EdgeInsets.on ly(right: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            final raw = category.image;
                                            final imageUrl =
                                                (raw == null || raw.isEmpty)
                                                ? kNoImageUrl
                                                : (raw.startsWith('http')
                                                      ? raw
                                                      : '$urlImg$raw');

                                            return GestureDetector(
                                              onTap: () => Get.toNamed(
                                                Routes.VIEW_ALL_PRODUCT,
                                                arguments: category.id,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (
                                                        context,
                                                        child,
                                                        loadingProgress,
                                                      ) {
                                                        if (loadingProgress ==
                                                            null)
                                                          return child;
                                                        return SizedBox(
                                                          width:
                                                              Get.width * 0.15,
                                                          height:
                                                              Get.width * 0.15,
                                                          child: const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Image.network(
                                                          kNoImageUrl,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        category.name ?? "",
                                        //   textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    // Banner section as a sliver
                    if (controller.products.value.featuredProducts != null &&
                        controller.products.value.featuredProducts!.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          child: SizedBox(
                            height: Get.height * 0.2,
                            child: CarouselHeader(controller: controller),
                          ),
                        ),
                      ),

                    // Product categories list as slivers
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: controller.products.value.categories != null
                            ? controller.products.value.categories!.length
                            : 0,
                        (context, index) {
                          final category =
                              controller.products.value.categories![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 0.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      category.name ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(
                                          Routes.VIEW_ALL_PRODUCT,
                                          arguments: category.id,
                                        );
                                        controller.getProductsByCategory(
                                          cateId: category.id!,
                                          pageNum: 1,
                                        );
                                      },

                                      child: Text('View All'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: Get.height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: category.products!.length,
                                    itemBuilder: (context, index) {
                                      final product = category.products![index];

                                      return SizedBox(
                                        width: Get.width * 0.5,
                                        height: Get.height * 0.28,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: ProductCard(
                                            saveProduct: () =>
                                                controller.toggleSaveProduct(
                                                  // ← toggleSaveProduct not saveProducts
                                                  productId: product.id!,
                                                  currentlySaved:
                                                      controller
                                                          .savedStatusMap[product
                                                          .id] ??
                                                      false,
                                                ),
                                            product: product,
                                            controller: controller,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
