class ProductModel {
  final String productId;
  final String productName;
  final String productCategory;
  final double productPrice;
  final String? productImageUrl;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productPrice,
    this.productImageUrl,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'productCategory': productCategory,
      'productName': productName,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
    };
  }

  // Convert Firestore document to ProductModel
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      productId: id,
      productName: data['productName'] ?? '',
      productCategory: data['productCategory'] ?? '',
      productPrice: (data['productPrice'] ?? 0).toDouble(),
      productImageUrl: data['productImageUrl'],
    );
  }
}
