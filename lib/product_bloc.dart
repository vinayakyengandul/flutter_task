import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/product_evnt.dart';
import 'package:flutter_task/repo.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'Product_BL.dart';
import 'database_helper.dart';
import 'model.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  int page = 1;
  bool isFetching = false;
  final box = GetStorage();
  final dbHelper = DatabaseHelper.instance;

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

  void addLocal(ProductModel _products) async {
    final allRows = await dbHelper.queryAllRows();
    var selected =
        allRows.where((element) => element["id"] == _products.id).toList();
    if (selected.isEmpty) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: _products.id,
        DatabaseHelper.columnTitle: _products.title,
        DatabaseHelper.columnSlug: _products.slug,
        DatabaseHelper.columnDescription: _products.description,
        DatabaseHelper.columnPrice: _products.price,
        DatabaseHelper.columnImg: _products.featuredImage,
        DatabaseHelper.columnStatus: _products.status,
        DatabaseHelper.columnCreatedAt: _products.createdAt.toString(),
      };
      final id = await dbHelper.insert(row);
      print('inserted row id: $id');
    } else {
      final rowsDeleted = await dbHelper.delete(selected[0]["id"]);
      print('deleted $rowsDeleted row(s): row ${selected[0]["id"]}');
    }
  }
}
