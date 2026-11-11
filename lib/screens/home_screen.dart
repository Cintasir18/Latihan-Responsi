import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService productService = ProductService();
  final GlobalKey _productSectionKey = GlobalKey();

  late Future<List<Product>> productsFuture;

  void scrollToProducts() {
    final context = _productSectionKey.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    productsFuture = productService.getProducts();
  }

  void retryLoadProducts() {
    setState(() {
      productsFuture = productService.getProducts();
    });
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(username: widget.username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: productsFuture,
          builder: (context, snapshot) {
            final products = snapshot.data ?? [];

            return CustomScrollView(
              slivers: [
                // HEADER
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MOYA',
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 4,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'CURATED COLLECTION',
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 2,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: openCart,
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 25,
                          ),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),

                // GREETING
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning, ${widget.username}.',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'What are you looking for today?',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // PROMOTION BANNER
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DISCOVER OUR COLLECTION',
                                  style: TextStyle(
                                    fontSize: 9,
                                    letterSpacing: 1.5,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Find your favorite products.',
                                  style: TextStyle(
                                    fontSize: 23,
                                    height: 1.2,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton(
                                  onPressed: scrollToProducts,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(120, 38),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  child: const Text('SHOP NOW'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 90,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // PRODUCT TITLE
                SliverToBoxAdapter(
                  key: _productSectionKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Featured Products',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          snapshot.hasData
                              ? '${products.length} products'
                              : 'Loading...',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                // ERROR
                else if (snapshot.hasError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_outlined,
                              size: 48,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Products could not be loaded.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: retryLoadProducts,
                              child: const Text('TRY AGAIN'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                // EMPTY
                else if (products.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No products available.')),
                  )
                // PRODUCT GRID
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ProductCard(
                          product: products[index],
                          username: widget.username,
                        );
                      }, childCount: products.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.63,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                          ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
