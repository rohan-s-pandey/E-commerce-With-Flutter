import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'checkout_screen.dart';
import 'product_detail_screen.dart';
import 'dummy_data.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Use the same color as the login page
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text('No items in the cart.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) {
                  final item = cart.items[index];
                  final product = dummyProducts.firstWhere((prod) =>
                      prod.id == item.id); // Find the corresponding Product

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(product.imageUrl,
                          width: 50, height: 50), // Show product image
                      title: Text(product.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          '\₹${product.price.toStringAsFixed(2)} x ${item.quantity}'),
                      onTap: () {
                        // Navigate to ProductDetailScreen when the item is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                                product: product), // Pass the product instance
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Call the removeItem method to delete the item
                          cart.removeItem(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${product.name} removed from cart!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null // No bottom navigation bar if cart is empty
          : BottomAppBar(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green "Add to Cart" button
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Adjusts size to fit content
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white, // Icon color
                    ),
                    SizedBox(width: 8), // Space between icon and text
                    Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
