import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task/repo.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'card_BL.dart';
import 'card_state.dart';
import 'model.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ProductRepository shopDataProvider = ProductRepository();
  ShopBloc() : super(ShopInitial()) {
    add(ShopPageInitializedEvent());
  }

  final box = GetStorage();

//
  @override
  Stream<ShopState> mapEventToState(
      ShopEvent event,
      ) async* {
    if (event is ShopPageInitializedEvent) {
      print(box.listenable.value!.values.toList());
      List<ProductModel> shopData = box.listenable.value!.values.toList().cast<ProductModel>().toList();
      List<ProductModel> cartData = box.listenable.value!.values.cast<ProductModel>().toList();
      yield ShopPageLoadedState(shopData: shopData, cartData: cartData);
    }
    if (event is ItemAddingCartEvent) {
      yield ItemAddingCartState(cartItems: event.cartItems);
    }
    if (event is ItemAddedCartEvent) {
      yield ItemAddedCartState(cartItems: event.cartItems);
    }
    if (event is ItemDeleteCartEvent) {
      yield ItemDeletingCartState(cartItems: event.cartItems!);
    }
  }
}
