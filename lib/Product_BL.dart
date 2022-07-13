import 'package:flutter/foundation.dart';

import 'model.dart';

abstract class ProductState {
  const ProductState();
}

class ProductInitialState extends ProductState {
  const ProductInitialState();
}

class ProductLoadingState extends ProductState {
  final String message;

  const ProductLoadingState({
    required this.message,
  });
}

class ProductSuccessState extends ProductState {
  final List<ProductModel> products;

  const ProductSuccessState({
    required this.products,
  });
}

class ProductErrorState extends ProductState {
  final String error;

  const ProductErrorState({
    required this.error,
  });
}