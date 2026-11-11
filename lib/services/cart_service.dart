import 'package:hive/hive.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static Box get _box => Hive.box('cart');

  static List<CartItem> getCart(String username) {
    final List<dynamic> savedItems =
        _box.get(username, defaultValue: <dynamic>[]) as List<dynamic>;

    return savedItems
        .map((item) => CartItem.fromMap(item as Map<dynamic, dynamic>))
        .toList();
  }

  static Future<void> addProduct({
    required String username,
    required Product product,
    required int quantity,
  }) async {
    final List<CartItem> items = getCart(username);
    final int existingIndex =
        items.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      final CartItem oldItem = items[existingIndex];
      final int newQuantity =
          (oldItem.quantity + quantity).clamp(1, product.stock).toInt();

      items[existingIndex] = CartItem(
        username: username,
        productId: oldItem.productId,
        title: oldItem.title,
        price: oldItem.price,
        thumbnail: oldItem.thumbnail,
        quantity: newQuantity,
      );
    } else {
      items.add(
        CartItem(
          username: username,
          productId: product.id,
          title: product.title,
          price: product.price,
          thumbnail: product.thumbnail,
          quantity: quantity,
        ),
      );
    }

    await _box.put(
      username,
      items.map((item) => item.toMap()).toList(),
    );
  }

  static Future<void> removeProduct({
    required String username,
    required int productId,
  }) async {
    final List<CartItem> items = getCart(username);
    items.removeWhere((item) => item.productId == productId);

    await _box.put(
      username,
      items.map((item) => item.toMap()).toList(),
    );
  }
}
