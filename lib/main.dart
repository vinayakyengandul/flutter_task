import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/product_bloc.dart';
import 'package:flutter_task/repo.dart';
import 'package:hive/hive.dart';
import 'display_product_screen.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  Bloc.observer = ProductBlocObserver();
    await GetStorage.init();
  runApp(ProductApp());
}

class ProductApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      initialRoute: '/',
      home: BlocProvider(
        create: (context) => ProductBloc(productRepository: ProductRepository()),
        child: DisplayProductScreen(),
      ),
    );
  }
}

class ProductBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(cubit, error, stackTrace);
  }
}
