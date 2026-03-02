import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_product_controller.dart';

class SearchProductView extends GetView<SearchProductController> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  SearchProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      controller: searchController,
                      cancelSearch: () {
                        searchController.clear();
                        controller.hasSearched.value =
                            false; // ✅ go back to history
                        controller.products.clear();
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          controller.hasSearched.value =
                              false; // ✅ go back to history when cleared
                          controller.products.clear();
                        }
                      },
                      submit: (value) {
                        if (value.isNotEmpty) {
                          controller.searchProduct(search: value);
                          controller.searchProductsByText(
                            search: searchController.text,
                          );
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list_outlined),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(() {
                        if (!controller.isSearchLoading.value) {
                          return CircularProgressIndicator();
                        }
                        if (controller.hasSearched.value)
                          return SizedBox.shrink();

                        final data = controller.searchResults.value.data;
                        if (data == null || data.isEmpty)
                          return SizedBox.shrink();
                        return ListView.builder(
                          shrinkWrap: true, // ✅ required inside ScrollView
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              controller.searchResults.value.data!.length,
                          itemBuilder: (context, index) {
                            final item =
                                controller.searchResults.value.data![index];
                            return ListTile(
                              onTap: () {
                                searchController.text =
                                    item.text ?? ""; // ✅ update text field

                                controller.searchProduct(search: item.text);
                              },
                              title: Text(item.text ?? ""),
                              leading: Icon(Icons.history),
                              trailing: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  controller.searchResults.value.data!.removeAt(
                                    index,
                                  );
                                  controller.searchResults.refresh(); //
                                },
                              ),
                            );
                          },
                        );
                      }),
                      Obx(() {
                        if (!controller.hasSearched.value)
                          return SizedBox.shrink(); // ✅ hide until searched

                        if (controller.isLoading.value)
                          return Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Search results for "${searchController.text}"',
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    controller.hasSearched.value = false;
                                    // controller.searchProduct();
                                    searchController.clear();
                                    controller.isSearchLoading.value = true;
                                  },
                                ),
                              ],
                            ),
                            if (controller.products.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'No results found for "${searchController.text}"',
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.products.length,
                                itemBuilder: (context, index) {
                                  final product = controller.products[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      onTap: () {
                                        Get.toNamed(
                                          '/product-detail',
                                          arguments: product,
                                        );
                                      },
                                      leading: product.image != null
                                          ? Image.network(product.image!)
                                          : null,
                                      title: Text(product.name ?? ""),
                                      subtitle: Text(
                                        product.description ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Text(
                                        '\$${product.price}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String)? submit;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final Function()? cancelSearch;

  SearchBar({
    this.submit,
    this.onChanged,
    required this.controller,
    this.cancelSearch,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey),
          hintText: 'Search products',
          border: InputBorder.none,
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    widget.cancelSearch!();
                    setState(() {
                      widget.controller.clear();
                    });
                  },
                )
              : null,
        ),
        onFieldSubmitted: widget.submit,
        onChanged: (value) {
          widget.onChanged!(value);
          setState(() {}); // Update state to show/hide the clear icon
        },
      ),
    );
  }
}
