import 'package:admin/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductItem({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  product.productImageUrl != null &&
                          product.productImageUrl!.isNotEmpty
                      ? Image.network(
                        product.productImageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                        ),
                      ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.productCategory,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Price: \$${product.productPrice.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
