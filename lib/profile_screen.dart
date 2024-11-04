import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    _addressController.text = user.address;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: ${user.phoneNumber}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Address:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Update Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userProvider.updateAddress(_addressController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Address updated successfully!')),
                );
              },
              child: Text('Update Address'),
            ),
          ],
        ),
      ),
    );
  }
}
