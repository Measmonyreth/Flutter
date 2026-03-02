import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_flutter/app/constant/constant.dart';
import 'package:ecommerce_flutter/app/data/model/product.rest.model.dart';
import 'package:ecommerce_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselHeader extends StatelessWidget {
  const CarouselHeader({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final featured = controller.products.value.featuredProducts!;
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: featured.length > 1,
          reverse: true,
          padEnds: true,
          viewportFraction: 1,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.easeInOutCubic,
        ),
        itemCount: featured.length,
        itemBuilder: (context, index, pageIndex) {
          final banner = featured[index];

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.12),
                  theme.colorScheme.secondary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Text Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Featured',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Product Name
                        Text(
                          banner.name ?? "",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Description
                        Text(
                          banner.description ?? "",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Price (if available)
                        if (banner.price != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            '\$${banner.price}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),

                        // Shop Now Button
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            onPressed: () {
                              final f = featured[index];
                              final product = Products(
                                id: f.id,
                                name: f.name,
                                description: f.description,
                                price: f.price,
                              );
                              Get.toNamed(
                                '/product-detail',
                                arguments: product,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward, size: 13),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right: Product Image
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          "${banner.image}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40,
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.4),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
