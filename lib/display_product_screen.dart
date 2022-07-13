import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/product_bloc.dart';
import 'package:flutter_task/product_body.dart';
import 'package:flutter_task/product_evnt.dart';
import 'package:flutter_task/repo.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Product_BL.dart';
import 'card_BL.dart';
import 'card_block.dart';
import 'card_state.dart';
import 'cart_items.dart';

class DisplayProductScreen extends StatefulWidget {

  @override
  State<DisplayProductScreen> createState() => _DisplayProductScreenState();
}

class _DisplayProductScreenState extends State<DisplayProductScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        productRepository: ProductRepository(),
      )..add(ProductFetchEvent()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Shopping Mall'),
          actions: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(primary: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) => ShopBloc(),
                                  // value: BlocProvider.of<ShopBloc>(context),
                                  child: ShoppingCart())));
                    },
                    icon: Icon(Icons.shopping_cart),
                    label: Text(''),
                    key: Key('cart'),
                  ),
                ),
                BlocBuilder<ProductBloc, ProductState>(builder: (_, cartState) {
                  // List<int> cartItem = cartState.;
                  final box = GetStorage();
                  return Positioned(
                  left: 30,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red),
                    child: Text(
                      // '${context.}',
                      '${box.listenable.value?.length}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );

                }),
              ],
            ),
          ],
        ),
        body: ProductBody(),
      ),
    );
  }
}
