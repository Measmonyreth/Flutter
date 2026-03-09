import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_flutter/app/constant/constant.dart';
import 'package:ecommerce_flutter/app/data/model/Response/save.rest.model.dart';
import 'package:ecommerce_flutter/app/data/model/product.rest.model.dart';
import 'package:ecommerce_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:ecommerce_flutter/app/modules/product-detail/views/product_detail_view.dart';
import 'package:ecommerce_flutter/app/modules/widget/List_cartProduct.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  ProductCard({
    super.key,
    required this.product,
    required this.controller,
    this.saveProduct,
  });

  final Products product;
  final HomeController controller;
  final Function()? saveProduct;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleSave() {
    _animController.forward().then((_) => _animController.reverse());

    // ✅ isProductSaved is sync — no await needed
    final isSaved =
        widget.controller.savedStatusMap[widget.product.id] ?? false;

    widget.controller.toggleSaveProduct(
      productId: widget.product.id!,
      currentlySaved: isSaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = widget.controller;
    final theme = context.theme;

    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailView(product: widget.product));
      },
      child: Hero(
        transitionOnUserGestures: true,
        tag: widget.product.id!,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image Section ──────────────────────────────
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        // implement when image is from list product by category and product detail
                        imageUrl: '${widget.product.image ?? ""}',

                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay at bottom of image
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.25),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Favorite button on top-right of image
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Obx(() {
                          final isSaved =
                              widget.controller.savedStatusMap[widget
                                  .product
                                  .id] ??
                              false;
                          final isLoading = widget.controller.loadingProducts
                              .contains(widget.product.id);

                          return GestureDetector(
                            onTap: isLoading ? null : _handleSave,
                            child: AnimatedBuilder(
                              animation: _scaleAnim,
                              builder: (context, child) => Transform.scale(
                                scale: _scaleAnim.value,
                                child: child,
                              ),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSaved
                                      ? Colors.blue[400]
                                      : Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isLoading
                                    ? Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: isSaved
                                              ? Colors.white
                                              : Colors.lightBlueAccent,
                                        ),
                                      )
                                    : Icon(
                                        isSaved
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 18,
                                        color: isSaved
                                            ? Colors.white
                                            : Colors.grey[700],
                                      ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // ── Info Section ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '\$${widget.product.price?.toString()}',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          // Optional: small add-to-cart chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
