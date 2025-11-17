import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() => {
        'product': {
          'id': product.id,
          'name': product.name,
          'image': product.image,
          'price': product.price,
          'rating': product.rating,
          'reviewCount': product.reviewCount,
          'category': product.category,
          'description': product.description,
        },
        'quantity': quantity,
      };

  factory CartItem.fromMap(Map<String, dynamic> map) {
    final p = map['product'] as Map<String, dynamic>;
    return CartItem(
      product: Product(
        id: (p['id'] ?? '').toString(),
        name: p['name']?.toString() ?? '',
        image: p['image']?.toString() ?? '',
        price: (p['price'] is num) ? (p['price'] as num).toDouble() : double.tryParse(p['price']?.toString() ?? '0') ?? 0.0,
        rating: (p['rating'] is num) ? (p['rating'] as num).toDouble() : double.tryParse(p['rating']?.toString() ?? '0') ?? 0.0,
        reviewCount: (p['reviewCount'] is int) ? p['reviewCount'] as int : int.tryParse(p['reviewCount']?.toString() ?? '0') ?? 0,
        category: p['category']?.toString() ?? '',
        description: p['description']?.toString() ?? '',
      ),
      quantity: (map['quantity'] is int) ? map['quantity'] as int : int.tryParse(map['quantity']?.toString() ?? '0') ?? 1,
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  CartProvider() {
    // Listen to auth changes: load/clear cart accordingly
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        loadCartFromFirestore(user.uid);
      } else {
        // If signed out, keep in-memory cleared (or keep local items if you prefer)
        _items.clear();
        notifyListeners();
      }
    });
  }

  // Load cart for given user from Firestore
  Future<void> loadCartFromFirestore(String uid) async {
    try {
      final snap = await _firestore.collection('users').doc(uid).collection('cartItems').get();
      _items.clear();
      for (final doc in snap.docs) {
        final data = doc.data();
        _items.add(CartItem.fromMap(data));
      }
      notifyListeners();
    } catch (e) {
      // ignore or log
      print('Load cart error: $e');
    }
  }

  Future<void> _saveCartItemToFirestore(String uid, CartItem item) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('cartItems')
          .doc(item.product.id)
          .set(item.toMap());
    } catch (e) {
      print('Save cart item error: $e');
    }
  }

  Future<void> _removeCartItemFromFirestore(String uid, String productId) async {
    try {
      await _firestore.collection('users').doc(uid).collection('cartItems').doc(productId).delete();
    } catch (e) {
      print('Remove cart item error: $e');
    }
  }

  Future<void> _clearCartInFirestore(String uid) async {
    try {
      final col = _firestore.collection('users').doc(uid).collection('cartItems');
      final snap = await col.get();
      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Clear cart error: $e');
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    // persist if user logged in
    final user = _auth.currentUser;
    if (user != null) {
      final item = _items.firstWhere((it) => it.product.id == product.id);
      _saveCartItemToFirestore(user.uid, item);
    }

    notifyListeners();
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);

    final user = _auth.currentUser;
    if (user != null) {
      _removeCartItemFromFirestore(user.uid, productId);
    }

    notifyListeners();
  }

  // Tăng số lượng sản phẩm
  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      _items[index].quantity++;
      final user = _auth.currentUser;
      if (user != null) _saveCartItemToFirestore(user.uid, _items[index]);
      notifyListeners();
    }
  }

  // Giảm số lượng sản phẩm
  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        final user = _auth.currentUser;
        if (user != null) _saveCartItemToFirestore(user.uid, _items[index]);
      } else {
        removeFromCart(productId);
      }
      notifyListeners();
    }
  }

  // Cập nhật số lượng sản phẩm
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
        final user = _auth.currentUser;
        if (user != null) _saveCartItemToFirestore(user.uid, _items[index]);
      } else {
        removeFromCart(productId);
      }
      notifyListeners();
    }
  }

  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    final user = _auth.currentUser;
    if (user != null) {
      _clearCartInFirestore(user.uid);
    }
    _items.clear();
    notifyListeners();
  }

  // Kiểm tra sản phẩm có trong giỏ hàng không
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Lấy số lượng của một sản phẩm trong giỏ hàng
  int getQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index >= 0 ? _items[index].quantity : 0;
  }
}