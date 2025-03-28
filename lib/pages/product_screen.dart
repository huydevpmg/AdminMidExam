import 'dart:io';

import 'package:admin/model/product_model.dart';
import 'package:admin/services/image_service.dart';
import 'package:admin/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String? userEmail;

  const ProductScreen({super.key, this.userEmail});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService productService = ProductService();
  final ImageService _imageService = ImageService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController searchController =
      TextEditingController(); // Controller for search bar

  File? selectedImage;
  String searchQuery = ""; // Holds the current search query

  void showProductDialog(BuildContext context, {ProductModel? product}) {
    nameController.text = product?.productName ?? '';
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
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Product Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: "Price",
                        border: OutlineInputBorder(),
                      ),
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
                      productName: nameController.text,
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
      appBar: AppBar(
        title: const Text("Product Management"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Logged in as: ${widget.userEmail}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by Name or Category",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase(); // Update search query
                });
              },
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

                  final products =
                      snapshot.data!
                          .where(
                            (product) =>
                                product.productName.toLowerCase().contains(
                                  searchQuery,
                                ) ||
                                product.productCategory.toLowerCase().contains(
                                  searchQuery,
                                ),
                          )
                          .toList();

                  if (products.isEmpty) {
                    return const Center(
                      child: Text(
                        "No products found",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading:
                              product.productImageUrl != null
                                  ? Image.network(
                                    product.productImageUrl!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(Icons.image, size: 50),
                          title: Text(
                            product.productName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Category: ${product.productCategory}\nPrice: \$${product.productPrice.toStringAsFixed(2)}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed:
                                    () => showProductDialog(
                                      context,
                                      product: product,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => productService.deleteProduct(
                                      product.productId,
                                    ),
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProductDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
