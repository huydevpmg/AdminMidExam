import 'package:admin/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference _products = FirebaseFirestore.instance.collection(
    'products',
  );
  Future<void> addProduct(ProductModel product) async {
    final docRef = _products.doc(); // Auto-generate ID
    await docRef.set(product.toFirestore()..['productId'] = docRef.id);
  }

  // Update Product (New Image or Details)
  Future<void> updateProduct(ProductModel product) async {
    await _products.doc(product.productId).update(product.toFirestore());
  }

  // Delete Product
  Future<void> deleteProduct(String productId) async {
    await _products.doc(productId).delete();
  }

  // Read Products (Stream)
  Stream<List<ProductModel>> getProducts() {
    return _products.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
}
