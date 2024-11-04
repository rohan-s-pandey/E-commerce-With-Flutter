import 'package:flutter/material.dart';
import 'order.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text('Address: ${order.address}'),
            SizedBox(height: 8),
            Text('Payment Method: ${order.paymentMethod}'),
            SizedBox(height: 8),
            Text('Date: ${order.date.toLocal().toString().split(' ')[0]}'),
            SizedBox(height: 16),
            Text('Items:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...order.items.map((item) => Text(
                  '${item.name} - \$${item.price.toStringAsFixed(2)} x${item.quantity}',
                  style: TextStyle(fontSize: 14),
                )),
          ],
        ),
      ),
    );
  }
}
