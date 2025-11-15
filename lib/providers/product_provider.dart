import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'Tất cả';

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  // Categories
  final List<String> categories = [
    'Tất cả',
    'Điện tử',
    'Thời trang',
    'Phụ kiện',
  ];

  ProductProvider() {
    // Load sample products khi khởi tạo
    _loadSampleProducts();
  }

  // Load sample products (có thể thay bằng API call sau)
  void _loadSampleProducts() {
    _products = [
      Product(
        id: '1',
        name: 'Tai nghe Bluetooth Premium',
        image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        price: 1299000,
        rating: 4.5,
        reviewCount: 128,
        category: 'Điện tử',
        description: 'Tai nghe Bluetooth cao cấp với chất lượng âm thanh Hi-Fi, chống ồn chủ động ANC, pin 30h. Thiết kế sang trọng, êm ái khi đeo lâu. Kết nối Bluetooth 5.0 ổn định, hỗ trợ nhiều thiết bị.',
      ),
      Product(
        id: '2',
        name: 'Giày thể thao Running',
        image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        price: 2199000,
        rating: 4.8,
        reviewCount: 256,
        category: 'Thời trang',
        description: 'Giày chạy bộ chuyên nghiệp với đệm Air Zoom cực êm, phù hợp chạy đường dài. Thiết kế nhẹ, thoáng khí, bền bỉ. Đế cao su chống trơn trượt hiệu quả.',
      ),
      Product(
        id: '3',
        name: 'Đồng hồ thông minh SmartWatch',
        image: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=400',
        price: 3499000,
        rating: 4.6,
        reviewCount: 189,
        category: 'Điện tử',
        description: 'Đồng hồ thông minh theo dõi sức khỏe toàn diện: nhịp tim, SpO2, giấc ngủ. Màn hình AMOLED sắc nét, pin 7 ngày. Chống nước IP68, nhiều chế độ thể thao.',
      ),
      Product(
        id: '4',
        name: 'Balo laptop cao cấp',
        image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
        price: 899000,
        rating: 4.4,
        reviewCount: 93,
        category: 'Phụ kiện',
        description: 'Balo đựng laptop 15.6 inch an toàn với ngăn chống sốc. Chất liệu chống nước, nhiều ngăn tiện dụng. Thiết kế thời trang, phù hợp đi làm, đi học.',
      ),
      Product(
        id: '5',
        name: 'Máy ảnh Mirrorless',
        image: 'https://images.unsplash.com/photo-1606980702931-c1c55bd8f58f?w=400',
        price: 15999000,
        rating: 4.9,
        reviewCount: 445,
        category: 'Điện tử',
        description: 'Máy ảnh mirrorless full-frame 24MP, quay video 4K 60fps. Lấy nét nhanh, chống rung 5 trục. Phù hợp nhiếp ảnh chuyên nghiệp và quay phim.',
      ),
    ];

    _filteredProducts = _products;
    notifyListeners();
  }

  // Lọc sản phẩm theo category
  void filterByCategory(String category) {
    _selectedCategory = category;

    if (category == 'Tất cả') {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) => product.category == category)
          .toList();
    }

    notifyListeners();
  }

  // Tìm kiếm sản phẩm
  void searchProducts(String query) {
    if (query.isEmpty) {
      if (_selectedCategory == 'Tất cả') {
        _filteredProducts = _products;
      } else {
        filterByCategory(_selectedCategory);
      }
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  // Load products from API (TODO: implement)
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Call API to load products
      await Future.delayed(const Duration(seconds: 2));

      // For now, use sample data
      _loadSampleProducts();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Không thể tải sản phẩm. Vui lòng thử lại.';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    if (category == 'Tất cả') {
      return _products;
    }
    return _products.where((p) => p.category == category).toList();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}