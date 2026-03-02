import 'package:ecommerce_flutter/app/constant/constant.dart';
import 'package:ecommerce_flutter/app/data/model/product.rest.model.dart';
import 'package:ecommerce_flutter/app/modules/product-detail/views/product_detail_view.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard({super.key, required this.product});
  final Products product; // replace with your Product model type

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () {
            // Navigate to product detail view
            Get.to(() => ProductDetailView(product: product));
          },
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '${urlImg}${product.image ?? ""}',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? "No name",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price ?? "0.00"}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE63946),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Quantity Controls
              // Column(
              //   children: [
              //     _QuantityButton(
              //       icon: Icons.add,
              //       onTap: () {
              //         // homeController.increaseQty(product.id)
              //       },
              //     ),
              //     const SizedBox(height: 4),
              //     const Text(
              //       '1', // replace with product.qty
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16,
              //       ),
              //     ),
              //     const SizedBox(height: 4),
              //     _QuantityButton(
              //       icon: Icons.remove,
              //       onTap: () {
              //         // homeController.decreaseQty(product.id)
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF1A1A2E)),
      ),
    );
  }
}
