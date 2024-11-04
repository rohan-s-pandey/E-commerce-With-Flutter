import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_provider.dart';
import 'order_details_page.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Use the same color as the login page
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'Nothing To Show.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Order #${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                        SizedBox(height: 4),
                        Text(
                            'Date: ${order.date.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<OrderProvider>(context, listen: false)
                            .cancelOrder(order.id);
                      },
                    ),
                    onTap: () {
                      // Navigate to OrderDetailsPage
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
