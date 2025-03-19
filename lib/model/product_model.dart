class ProductModel {
  final String productId;
  final String productCategory;
  final double productPrice;
  final String? productImageUrl;

  ProductModel({
    required this.productId,
    required this.productCategory,
    required this.productPrice,
    this.productImageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] as String,
      productCategory: json['productCategory'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productImageUrl: json['productImageUrl'] as String?,
    );
  }

  // Method to convert a ProductModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productCategory': productCategory,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productCategory': productCategory,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
    };
  }

   // Convert Firestore document to ProductModel
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      productId: id,
      productCategory: data['productCategory'] ?? '',
      productPrice: (data['productPrice'] ?? 0).toDouble(),
      productImageUrl: data['productImageUrl'],
    );
  }

}
