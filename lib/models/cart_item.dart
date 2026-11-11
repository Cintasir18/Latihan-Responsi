class CartItem {
  final String username;
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  final int quantity;

  const CartItem({
    required this.username,
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<dynamic, dynamic> map) {
    return CartItem(
      username: map['username']?.toString() ?? '',
      productId: (map['productId'] as num).toInt(),
      title: map['title']?.toString() ?? '-',
      price: (map['price'] as num).toDouble(),
      thumbnail: map['thumbnail']?.toString() ?? '',
      quantity: (map['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'productId': productId,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'quantity': quantity,
    };
  }

  double get subtotal => price * quantity;
}
