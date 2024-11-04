import 'package:flutter/material.dart';
import 'product.dart'; // Make sure to import your Product model
import 'dart:math';

class AddProductsPage extends StatefulWidget {
  final Function(Product) onProductAdded;

  AddProductsPage({required this.onProductAdded});

  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productImageController = TextEditingController();

  // Function to submit the product details
  void _submitProduct() {
    final String name = _productNameController.text.trim();
    final String description = _productDescriptionController.text.trim();
    final String price = _productPriceController.text.trim();
    final String image = _productImageController.text.trim();

    // Validation checks
    if (name.isEmpty || description.isEmpty || price.isEmpty || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    // Create a new product
    final newProduct = Product(
      id: 'p${Random().nextInt(1000)}', // Generate a random id for simplicity
      name: name,
      price: double.tryParse(price) ?? 0.0,
      imageUrl: image,
      description: description,
    );

    // Call the callback function to add the product to the list
    widget.onProductAdded(newProduct);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product added: $name')),
    );

    // Clear the fields
    _productNameController.clear();
    _productDescriptionController.clear();
    _productPriceController.clear();
    _productImageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Products'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _productDescriptionController,
              decoration: InputDecoration(
                labelText: 'Product Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _productPriceController,
              decoration: InputDecoration(
                labelText: 'Product Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _productImageController,
              decoration: InputDecoration(
                labelText: 'Product Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitProduct,
              child: Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
