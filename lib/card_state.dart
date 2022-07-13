import 'package:equatable/equatable.dart';
import 'package:flutter_task/model.dart';


abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

class ShopInitial extends ShopState {}

class ShopPageLoadedState extends ShopState {
  List<ProductModel> shopData;
  List<ProductModel> cartData;

  ShopPageLoadedState({required this.cartData,required this.shopData});
}

class ItemAddingCartState extends ShopState {
  List<ProductModel>? cartData;
  List<ProductModel>? cartItems;

  ItemAddingCartState({this.cartData, this.cartItems});
}

class ItemAddedCartState extends ShopState {
  List<ProductModel> cartItems;

  ItemAddedCartState({required this.cartItems});
}

class ItemDeletingCartState extends ShopState {
  List<ProductModel> cartItems;

  ItemDeletingCartState({required this.cartItems});
}
