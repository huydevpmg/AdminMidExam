import 'dart:io';

import 'package:admin/model/product_model.dart';
import 'package:admin/services/image_service.dart';
import 'package:admin/services/product_service.dart';
import 'package:admin/widgets/product_item.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService productService = ProductService();
  final ImageService _imageService = ImageService();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? selectedImage;

  void showProductDialog(BuildContext context, {ProductModel? product}) {
    categoryController.text = product?.productCategory ?? '';
    priceController.text = product?.productPrice.toString() ?? '';
    selectedImage = null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(product == null ? "Add Product" : "Edit Product"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: "Category"),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      File? image = await _imageService.pickImage();
                      if (image != null) {
                        setDialogState(() {
                          selectedImage = image;
                        });
                      }
                    },
                    child: const Text("Pick Image"),
                  ),
                  if (selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Selected File: ${selectedImage!.path.split('/').last}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    String? imageUrl = product?.productImageUrl;

                    if (selectedImage != null) {
                      imageUrl = await _imageService.uploadImage(
                        selectedImage!,
                        product?.productId ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                      );
                    }

                    final newProduct = ProductModel(
                      productId: product?.productId ?? '',
                      productCategory: categoryController.text,
                      productPrice:
                          double.tryParse(priceController.text) ?? 0.0,
                      productImageUrl: imageUrl,
                    );

                    if (product == null) {
                      await productService.addProduct(newProduct);
                    } else {
                      await productService.updateProduct(newProduct);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(product == null ? "Add" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              const Text(
                'List Of Product',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<List<ProductModel>>(
                  stream: productService.getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                          product: product,
                          onEdit:
                              () =>
                                  showProductDialog(context, product: product),
                          onDelete:
                              () => productService.deleteProduct(
                                product.productId,
                              ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProductDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
