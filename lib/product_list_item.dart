import 'package:flutter/material.dart';

import 'model.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;

  ProductListItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(product.title.toString()),
      childrenPadding: const EdgeInsets.all(16),
      leading: Container(
        margin: EdgeInsets.only(top: 8),
        child: Text(product.id.toString()),
      ),
      children: [
        Text(
          product.description.toString(),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 20),
        product.featuredImage == null
            ? Container()
            : Image.network(
          product.featuredImage.toString(),
          loadingBuilder: (context, widget, imageChunkEvent) {
            return imageChunkEvent == null
                ? widget
                : CircularProgressIndicator();
          },
          height: 300,
        ),
      ],
    );
  }
}