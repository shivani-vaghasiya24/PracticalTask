import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:practical_task_2/product/model/product.dart';

class ProductProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final String baseUrl = "https://dummyjson.com/products";
  int pageLimit = 20;
  bool _isLoading = false;
  bool _isMoreAvailable = true;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> categoryList = [];
  List<String> selectedCategoryList = [];
  List<String> brandList = [];
  List<String> selectedBrandList = [];

  List<Product> get products =>
      _filteredProducts.isNotEmpty ? _filteredProducts : _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  bool get isMoreAvailable => _isMoreAvailable;

  int totalRecords = 0;

  Future<void> fetchProducts(
    bool isFristTime,
  ) async {
    // if (_isLoading) return;

    print("fetchProductsfetchProductsfetchProducts");

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'skip': _products.length,
          'limit': (totalRecords != 0 &&
                  (_products.length + pageLimit) > totalRecords)
              ? (totalRecords - _products.length)
              : pageLimit,
        },
      );

      final List<Product> fetchedProducts = (response.data["products"] as List)
          .map((json) => Product.fromJson(json))
          .toList();
      totalRecords = response.data["total"];
      _products.addAll(fetchedProducts);
      _products.forEach(
        (element) {
          if ((element.category ?? "").isNotEmpty &&
              !categoryList.contains(element.category)) {
            categoryList.add(element.category!);
          }
          if ((element.brand ?? "").isNotEmpty &&
              !brandList.contains(element.brand)) {
            brandList.add(element.brand!);
          }
        },
      );
      notifyListeners();
      _isMoreAvailable = _products.length < totalRecords;
      _isLoading = false;
      print("MYLIST ${products.length}");
      notifyListeners();
    } catch (e, st) {
      // Handle error
      print('Error fetching products: $e');
      print(st);
    }

    _isLoading = false;
    notifyListeners();
  }

  selectCategory(String category) {
    if (selectedCategoryList.contains(category)) {
      selectedCategoryList.remove(category);
      _filteredProducts.removeWhere((product) => product.category == category);
    } else {
      selectedCategoryList.add(category);
      final resultProducts =
          _products.where((product) => product.category == category).toList();
      addProduct(resultProducts);
    }
    selectedBrandList.forEach(
      (brand) {
        final resultProducts =
            _products.where((product) => product.brand == brand).toList();
        addProduct(resultProducts);
      },
    );
    notifyListeners();
    // filterProduct(category);
  }

  selectBrand(String brand) {
    if (selectedBrandList.contains(brand)) {
      selectedBrandList.remove(brand);
      _filteredProducts.removeWhere((product) => product.brand == brand);
    } else {
      selectedBrandList.add(brand);
      final resultProducts =
          _products.where((product) => product.brand == brand).toList();
      addProduct(resultProducts);
    }
    selectedCategoryList.forEach(
      (category) {
        final resultProducts =
            _products.where((product) => product.category == category).toList();
        addProduct(resultProducts);
      },
    );
    notifyListeners();
    // filterProduct(category);
  }

  void addProduct(List<Product> resultProducts) {
    for (var product in resultProducts) {
      bool exists = _filteredProducts.any((p) => p.id == product.id);
      if (!exists) {
        _filteredProducts.add(product);
      }
    }
  }
}
