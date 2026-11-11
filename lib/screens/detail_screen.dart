import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  final String username;

  const DetailScreen({
    super.key,
    required this.product,
    required this.username,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;
  bool isSaving = false;

  Future<void> addToCart() async {
    if (widget.product.stock <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Stok produk habis.')));
      return;
    }

    setState(() {
      isSaving = true;
    });

    await CartService.addProduct(
      username: widget.username,
      product: widget.product,
      quantity: quantity,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil ditambahkan ke Cart.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Seluruh tampilan halaman Detail diletakkan di sini.

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(username: widget.username),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // GAMBAR PRODUK
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 280,
              width: double.infinity,
              color: AppColors.card,
              child: Image.network(
                widget.product.thumbnail,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    size: 60,
                    color: AppColors.secondary,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // KATEGORI DAN RATING
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product.category.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 17),
                  const SizedBox(width: 4),
                  Text(
                    widget.product.rating.toString(),
                    style: const TextStyle(fontSize: 13, color: AppColors.text),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // NAMA PRODUK
          Text(
            widget.product.title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 8),

          // BRAND
          Text(
            'Brand: ${widget.product.brand}',
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),

          const SizedBox(height: 14),

          // HARGA
          Text(
            '\$${widget.product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 24),

          const Divider(color: AppColors.card),

          const SizedBox(height: 12),

          // DESKRIPSI
          const Text(
            'Product Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: AppColors.muted,
            ),
          ),

          const SizedBox(height: 24),

          // STOK PRODUK
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Stock',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              Text(
                '${widget.product.stock} items',
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // QUANTITY SELECTOR
          const Text(
            'Quantity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              // TOMBOL KURANG
              IconButton(
                onPressed: quantity > 1
                    ? () {
                        setState(() {
                          quantity--;
                        });
                      }
                    : null,
                style: IconButton.styleFrom(backgroundColor: AppColors.card),
                icon: const Icon(Icons.remove),
              ),

              const SizedBox(width: 16),

              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(width: 16),

              // TOMBOL TAMBAH
              IconButton(
                onPressed: quantity < widget.product.stock
                    ? () {
                        setState(() {
                          quantity++;
                        });
                      }
                    : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // TOMBOL ADD TO CART
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isSaving || widget.product.stock <= 0
                  ? null
                  : addToCart,
              icon: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.shopping_bag_outlined),
              label: Text(
                widget.product.stock <= 0
                    ? 'OUT OF STOCK'
                    : isSaving
                    ? 'ADDING PRODUCT...'
                    : 'ADD TO CART',
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
