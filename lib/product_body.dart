import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/product_bloc.dart';
import 'package:flutter_task/product_evnt.dart';
import 'package:flutter_task/product_list_item.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Product_BL.dart';
import 'model.dart';

class ProductBody extends StatefulWidget {
  const ProductBody({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ProductBody> {
  final List<ProductModel> _products = [];
  final ScrollController _scrollController = ScrollController();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, productState) {
          if (productState is ProductLoadingState) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(productState.message)));
          } else if (productState is ProductSuccessState &&
              productState.products.isEmpty) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('No more Products')));
          } else if (productState is ProductErrorState) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(productState.error)));
            context.bloc<ProductBloc>().isFetching = false;
          }
          return;
        },
    child: BlocBuilder<ProductBloc, ProductState>(
    builder: (context, productState) {
          if (productState is ProductInitialState ||
              productState is ProductLoadingState && _products.isEmpty) {
            return CircularProgressIndicator();
          } else if (productState is ProductSuccessState) {
            _products.clear();
            _products.addAll(productState.products);
            context.bloc<ProductBloc>().isFetching = false;
            Scaffold.of(context).hideCurrentSnackBar();
          } else if (productState is ProductErrorState && _products.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.bloc<ProductBloc>()
                      ..isFetching = true
                      ..add(ProductFetchEvent());
                  },
                  icon: Icon(Icons.refresh),
                ),
                const SizedBox(height: 15),
                Text(productState.error, textAlign: TextAlign.center),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
                controller: _scrollController
                  ..addListener(() {
                    if (_scrollController.offset ==
                            _scrollController.position.maxScrollExtent &&
                        !context.bloc<ProductBloc>().isFetching) {
                      context.bloc<ProductBloc>()
                        ..isFetching = true
                        ..add(ProductFetchEvent());
                    }
                  }),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                itemCount: _products.length,
                itemBuilder: (BuildContext ctx, index) {
                  var data = box.read("${_products[index].id}");
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: Card(
                                color: Colors.blue,
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(20.0),
                                    ),
                                child: ClipRRect(
                                  // borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    _products[index].featuredImage.toString(),
                                    fit: BoxFit.fill,
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _products[index].title.toString(),
                                  ),
                                ),
                              ),
                              IconButton(
                                key: Key('icon_${_products[index].id}'),
                                // icon:  Icon(Icons.shopping_cart_outlined),
                                icon: data != null
                                        ? Icon(Icons.shopping_cart)
                                        : Icon(Icons.shopping_cart_outlined),
                                onPressed: () {
                                  setState(() {
                                    BlocProvider.of<ProductBloc>(context)
                                        .addLocal(_products[index]);
                                  });

                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
          // return ListView.separated(
          //   controller: _scrollController
          //     ..addListener(() {
          //       if (_scrollController.offset ==
          //           _scrollController.position.maxScrollExtent &&
          //           !context.bloc<ProductBloc>().isFetching) {
          //         context.bloc<ProductBloc>()
          //           ..isFetching = true
          //           ..add(ProductFetchEvent());
          //       }
          //     }),
          //   itemBuilder: (context, index) => ProductListItem(_products[index]),
          //   separatorBuilder: (context, index) => const SizedBox(height: 20),
          //   itemCount: _products.length,
          // );
        },
    )
      ),
    );
  }
}
