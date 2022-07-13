import 'package:equatable/equatable.dart';
import 'package:flutter_task/model.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class ShopPageInitializedEvent extends ShopEvent {}

class ItemAddingCartEvent extends ShopEvent {
  List<ProductModel> cartItems;

  ItemAddingCartEvent({required this.cartItems});
}

class ItemAddedCartEvent extends ShopEvent {
  List<ProductModel> cartItems;

  ItemAddedCartEvent({required this.cartItems});
}

class ItemDeleteCartEvent extends ShopEvent {
  List<ProductModel>? cartItems;
  int? index;
  ItemDeleteCartEvent({this.cartItems, this.index});
}
