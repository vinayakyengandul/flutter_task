import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import 'card_BL.dart';
import 'card_block.dart';
import 'card_state.dart';
import 'model.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<ProductModel>? cartItems;
  var box = GetStorage();

  double totalAmount = 0;
  void calculateTotalAmount(List<ProductModel> list) {
    double res = 0;

    list.forEach((element) {
      res = res + element.price!;
    });
    totalAmount = res;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ItemAddedCartState) {
          cartItems = state.cartItems;
          calculateTotalAmount(cartItems!);
        }
        if (state is ShopPageLoadedState) {
          cartItems = state.cartData;
          calculateTotalAmount(cartItems!);
        }
        if (state is ItemDeletingCartState) {
          cartItems = state.cartItems;
          calculateTotalAmount(cartItems!);
        }

        if (state is ItemAddingCartState) {
          cartItems = state.cartItems;
          calculateTotalAmount(cartItems!);
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0XFFF8F5B9),
            title: Text(
              'My Cart',
              style: TextStyle(color: Colors.purple),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          bottomNavigationBar: Container(
            height: 68,
            decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 8,
                    color: Color(0xFF000000).withOpacity(0.20),
                  ),
                  BoxShadow(
                    offset: Offset(0, -1),
                    blurRadius: 3,
                    color: Color(0xFF000000).withOpacity(0.20),
                  ),
                  BoxShadow(
                    offset: Offset(0, -1),
                    blurRadius: 4,
                    color: Color(0xFF000000).withOpacity(0.14),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                )),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Total Items',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      Text('${cartItems?.toList().length}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Grand Total',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      Text('\$${totalAmount.toStringAsFixed(2)}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                    ],
                  ),

                ],
              ),
            ),
          ),
          body: cartItems == null || cartItems!.length == 0
              ? Center(child: Text('Your Cart is Empty'))
              : ListView.builder(
            itemCount: cartItems!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.network(
                              cartItems![index].featuredImage!,
                              height: 64,
                              width: 64,
                            ),
                            SizedBox(width: 20),
                            Text(cartItems![index].title!),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                print("cartItems![index].id.toString()");
                                print(cartItems![index].id.toString());
                                setState(() {
                                  if (state is ShopPageLoadedState) {
                                     box.remove(cartItems![index].id.toString());
                                    state.cartData
                                        .removeAt(index);
                                        state.shopData.removeAt(index);
                                    calculateTotalAmount(cartItems!);
                                    BlocProvider.of<ShopBloc>(context)
                                      ..add(ItemDeleteCartEvent(
                                          cartItems: state.shopData
                                      ));
                                  } else if (state
                                  is ItemAddedCartState) {
                                    print("2");
                                     box.remove(cartItems![index].id.toString());

                                    state.cartItems.removeAt(index);
                                    calculateTotalAmount(cartItems!);

                                    BlocProvider.of<ShopBloc>(context)
                                      ..add(ItemDeleteCartEvent(
                                          cartItems: state.cartItems));
                                  } else if (state
                                  is ItemDeletingCartState) {
                                    print("3");
                                     box.remove(cartItems![index].id.toString());

                                    state.cartItems.removeAt(index);
                                    calculateTotalAmount(cartItems!);

                                    BlocProvider.of<ShopBloc>(context)
                                      ..add(ItemDeleteCartEvent(
                                          cartItems: state.cartItems));
                                  }
                                 
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 80),
                            Text("Price : ",style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("\$" +cartItems![index].price.toString()),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 80),
                            Text("Quantity : ",style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(1.toString()),
                          ],
                        )

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     IconButton(
                        //       icon: Icon(Icons.remove),
                        //       onPressed: () {
                        //         if (cartItems![index].! > 0)
                        //           setState(() {
                        //             calculateTotalAmount(cartItems!);
                        //             cartItems![index].quantity! - 1;
                        //           });
                        //       },
                        //     ),
                        //     SizedBox(
                        //       height: 20,
                        //       width: 30,
                        //       child: Container(
                        //         alignment: Alignment.center,
                        //         decoration: BoxDecoration(
                        //             border: Border.all(
                        //                 color: Colors.black, width: 0.5)),
                        //         child: Text(
                        //           cartItems![index].quantity.toString(),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ),
                        //     ),
                        //     IconButton(
                        //       icon: Icon(Icons.add),
                        //       onPressed: () {
                        //         setState(() {
                        //           calculateTotalAmount(cartItems!);
                        //           cartItems![index].quantity! + 1;
                        //         });
                        //       },
                        //     ),
                        //     Spacer(),
                        //     Text(
                        //         '\$${cartItems![index].price! * cartItems![index].quantity!} ')
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
