import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  static final ProductRepository _beerRepository = ProductRepository._();
  static const int _perPage = 10;

  ProductRepository._();

  factory ProductRepository() {
    return _beerRepository;
  }

  Future<dynamic> getProducts({
    required int page,
  }) async {
    try {
      return await http.post(
            Uri.parse('http://205.134.254.135/~mobile/MtProject/public/api/product_list.php'),
            body: {
              "page": page.toString(),
              "perPage": 5.toString()
            }
          ,
            headers: {
              "token" : "eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz"
            }
      );
    } catch (e) {
      return e.toString();
    }
  }
}