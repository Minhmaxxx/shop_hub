import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(Product product) {
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Nếu đã có, tăng số lượng
      _items[existingIndex].quantity++;
    } else {
      // Nếu chưa có, thêm mới
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Tăng số lượng sản phẩm
  void increaseQuantity(String productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // Giảm số lượng sản phẩm
  void decreaseQuantity(String productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Cập nhật số lượng sản phẩm
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Kiểm tra sản phẩm có trong giỏ hàng không
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Lấy số lượng của một sản phẩm trong giỏ hàng
  int getQuantity(String productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );
    return index >= 0 ? _items[index].quantity : 0;
  }
}