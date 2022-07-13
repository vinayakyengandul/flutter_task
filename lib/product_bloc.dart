import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/product_evnt.dart';
import 'package:flutter_task/repo.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'Product_BL.dart';
import 'model.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  int page = 1;
  bool isFetching = false;
  final box = GetStorage();

  ProductBloc({
    required this.productRepository,
  }) : super(ProductInitialState());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductFetchEvent) {
      yield ProductLoadingState(message: 'Loading Products');
      final response = await productRepository.getProducts(page: page);
      if (response is http.Response) {
        if (response.statusCode == 200) {
          final products = jsonDecode(response.body)["data"] as List;
          yield ProductSuccessState(
            products:
                products.map((prod) => ProductModel.fromJson(prod)).toList(),
          );
          page++;
        } else {
          yield ProductErrorState(error: response.body);
        }
      } else if (response is String) {
        yield ProductErrorState(error: response);
      }
    }
  }

  void addLocal(dynamic _products) async {
    var data = box.read(_products.id.toString());
    data == null
        ? box.write(_products.id.toString(), _products)
        : box.remove(_products.id.toString());
  }
}
