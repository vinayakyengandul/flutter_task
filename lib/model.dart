// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';
List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(json.decode(str))));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.idRec,
    this.slug,
    this.title,
    this.description,
    this.price,
    this.featuredImage,
    this.status,
    this.createdAt,
  });

  int? id;
  int? idRec;
  String? slug;
  String? title;
  String? description;
  int? price;
  String? featuredImage;
  String? status;
  DateTime? createdAt;

  factory ProductModel.fromJson(Map<String, dynamic> json, {int i = 0}) => ProductModel(
    id: json["id"],
    idRec: json["idRec"],
    slug: json["slug"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    featuredImage: json["featured_image"],
    status: json["status"],
    createdAt: i == 0 ? DateTime.parse(json["created_at"]) : json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idRec": idRec,
    "slug": slug,
    "title": title,
    "description": description,
    "price": price,
    "featured_image": featuredImage,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
  };
}
