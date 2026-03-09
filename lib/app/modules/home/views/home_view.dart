import 'package:ecommerce_flutter/app/constant/constant.dart';
import 'package:ecommerce_flutter/app/constant/theme.dart';
import 'package:ecommerce_flutter/app/data/model/Response/category.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/Response/save.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/product.rest.model.dart';
import 'package:ecommerce_flutter/app/modules/widget/carousel.dart';
import 'package:ecommerce_flutter/app/modules/widget/product_cart.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
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
                            onPressed: () async {
                              await Get.toNamed(Routes.SEARCH_PRODUCT);
                            },
                            icon: Icon(
                              Icons.search_sharp,
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
                    // if (controller.categories.value.data != null &&
                    //     controller.categories.value.data!.isNotEmpty &&
                    //     controller.isLoading.value == false)
                    //   SliverToBoxAdapter(
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 12.0,
                    //         vertical: 8.0,
                    //       ),
                    //       child: Container(
                    //         height: Get.height * 0.1,
                    //         child: ListView.builder(
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount:
                    //               controller.categories.value.data!.length,
                    //           itemBuilder: (context, index) {
                    //             final category =
                    //                 controller.categories.value.data![index];
                    //             return Padding(
                    //               padding: const EdgeInsets.only(right: 16.0),
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.center,
                    //                 children: [
                    //                   Container(
                    //                     width: Get.width * 0.15,
                    //                     //  margin: const EdgeInsets.on ly(right: 20),
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.circular(
                    //                         12,
                    //                       ),
                    //                     ),
                    //                     child: Builder(
                    //                       builder: (context) {
                    //                         // final raw = category.image;
                    //                         // final imageUrl =
                    //                         //     (raw == null || raw.isEmpty)
                    //                         //     ? kNoImageUrl
                    //                         //     : (raw.startsWith('http')
                    //                         //           ? raw
                    //                         //           : '$urlImg$raw');
                    //                         // final imageUrl = category.image;
                    //                         return GestureDetector(
                    //                           onTap: () => Get.toNamed(
                    //                             Routes.VIEW_ALL_PRODUCT,
                    //                             arguments: category.id,
                    //                           ),
                    //                           child: ClipRRect(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(12),
                    //                             child: Image.network(
                    //                               "${urlImg}${category.image}",
                    //                               fit: BoxFit.cover,
                    //                               loadingBuilder:
                    //                                   (
                    //                                     context,
                    //                                     child,
                    //                                     loadingProgress,
                    //                                   ) {
                    //                                     if (loadingProgress ==
                    //                                         null)
                    //                                       return child;
                    //                                     return SizedBox(
                    //                                       width:
                    //                                           Get.width * 0.15,
                    //                                       height:
                    //                                           Get.width * 0.15,
                    //                                       child: const Center(
                    //                                         child:
                    //                                             CircularProgressIndicator(
                    //                                               strokeWidth:
                    //                                                   2,
                    //                                             ),
                    //                                       ),
                    //                                     );
                    //                                   },
                    //                               errorBuilder:
                    //                                   (
                    //                                     context,
                    //                                     error,
                    //                                     stackTrace,
                    //                                   ) {
                    //                                     print(
                    //                                       "Image error: ${error.toString()}",
                    //                                     );
                    //                                     print(
                    //                                       "Failed URL: ${urlImg}${category.image}",
                    //                                     );
                    //                                     print(
                    //                                       "Category image: ${category.image}",
                    //                                     );
                    //                                     return Image.network(
                    //                                       kNoImageUrl,
                    //                                       fit: BoxFit.cover,
                    //                                     );
                    //                                   },
                    //                             ),
                    //                           ),
                    //                         );
                    //                       },
                    //                     ),
                    //                   ),
                    //                   const SizedBox(height: 5),
                    //                   Text(
                    //                     category.name ?? "",
                    //                     //   textAlign: TextAlign.center,
                    //                     style: const TextStyle(
                    //                       color: Colors.black,
                    //                       fontSize: 10,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ),

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
                            child: CarouselHeader(
                              featured:
                                  controller.products.value.featuredProducts!,
                            ),
                          ),
                        ),
                      ),

                    // category list
                    if (controller.categories.value.data != null &&
                        controller.categories.value.data!.isNotEmpty &&
                        controller.isLoading.value == false)
                      SliverToBoxAdapter(
                        child: OurProductsSection(
                          categories:
                              controller.products.value.categories ?? [],
                        ),
                      ),

                    // Product categories list as slivers
                    // SliverList(
                    //   delegate: SliverChildBuilderDelegate(
                    //     childCount: controller.products.value.categories != null
                    //         ? controller.products.value.categories!.length
                    //         : 0,
                    //     (context, index) {
                    //       final category =
                    //           controller.products.value.categories![index];
                    //       return Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //           horizontal: 12.0,
                    //           vertical: 0.0,
                    //         ),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             SizedBox(
                    //               height: Get.height * 0.20,
                    //               child: ListView.builder(
                    //                 scrollDirection: Axis.horizontal,
                    //                 itemCount: category.products!.length,
                    //                 itemBuilder: (context, index) {
                    //                   final product = category.products![index];

                    //                   return SizedBox(
                    //                     width: Get.width * 0.4,
                    //                     height: Get.height * 0.28,
                    //                     child: Container(
                    //                       margin: const EdgeInsets.only(
                    //                         right: 10,
                    //                         bottom: 10,
                    //                       ),
                    //                       child: ProductCard(
                    //                         saveProduct: () =>
                    //                             controller.toggleSaveProduct(
                    //                               // ← toggleSaveProduct not saveProducts
                    //                               productId: product.id!,
                    //                               currentlySaved:
                    //                                   controller
                    //                                       .savedStatusMap[product
                    //                                       .id] ??
                    //                                   false,
                    //                             ),
                    //                         product: product,
                    //                         controller: controller,
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
      );
    });
  }
}

Widget _builderProductCategory({required Data category}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        category.name ?? '',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

class OurProductsSection extends StatefulWidget {
  final List<Categories> categories; // ← pass categories directly

  const OurProductsSection({super.key, required this.categories});

  @override
  State<OurProductsSection> createState() => _OurProductsSectionState();
}

class _OurProductsSectionState extends State<OurProductsSection> {
  String selectedCategory = 'All Products';
  int? selectedCategoryId;

  List<Products> get filteredProducts {
    if (selectedCategoryId == null) {
      return widget.categories
          .expand<Products>((cat) => cat.products ?? [])
          .toList();
    }
    final category = widget.categories.firstWhere(
      (cat) => cat.id == selectedCategoryId,
      orElse: () => Categories(),
    );
    return category.products ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text(
            'Our Products',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              _buildFilterChip('All Products', null, null),
              ...widget.categories.map(
                (cat) => _buildFilterChip(cat.name ?? '', cat.id?.toInt(), cat),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 2-column product grid
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, // adjust to fit your card height
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return ProductCard(
              product: product,
              saveProduct: () {},
              controller: Get.find<HomeController>(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, int? categoryId, Categories? category) {
    final isSelected = selectedCategoryId == categoryId;
    return GestureDetector(
      onTap: () => setState(() => selectedCategoryId = categoryId),
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            if (category != null) ...[
              Image.network(category.image ?? '', width: 20, height: 20),
            ],
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
