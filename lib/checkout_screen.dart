import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_provider.dart';
import 'order_provider.dart';
import 'order.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressLine1Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _addressNameController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  String? _selectedPaymentMethod;
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _cityController.dispose();
    _addressNameController.dispose();
    _pincodeController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _addressNameController.text = prefs.getString('addressName') ?? '';
      _addressLine1Controller.text = prefs.getString('addressLine1') ?? '';
      _cityController.text = prefs.getString('city') ?? '';
      _pincodeController.text = prefs.getString('pincode') ?? '';
      _mobileNumberController.text = prefs.getString('mobileNumber') ?? '';
      _selectedState = prefs.getString('selectedState');
      _selectedPaymentMethod = prefs.getString('selectedPaymentMethod');
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('addressName', _addressNameController.text);
    prefs.setString('addressLine1', _addressLine1Controller.text);
    prefs.setString('city', _cityController.text);
    prefs.setString('pincode', _pincodeController.text);
    prefs.setString('mobileNumber', _mobileNumberController.text);
    prefs.setString('selectedState', _selectedState ?? '');
    prefs.setString('selectedPaymentMethod', _selectedPaymentMethod ?? '');
  }

  bool _validateInputs() {
    if (_addressNameController.text.isEmpty ||
        _addressLine1Controller.text.isEmpty ||
        _cityController.text.isEmpty ||
        _pincodeController.text.isEmpty ||
        _pincodeController.text.length != 6 ||
        _mobileNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cart.items.isEmpty
            ? Center(child: Text('No items in the cart.'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Address Section
                    Text('Shipping Address',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10),
                    _buildTextField(_addressNameController, 'Name'),
                    _buildTextField(_addressLine1Controller, 'Local Address'),
                    _buildTextField(_cityController, 'City'),
                    Text('State',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Select state'),
                      value: _selectedState,
                      items: _getStates(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedState = newValue;
                        });
                        _saveData();
                      },
                    ),
                    _buildTextField(_pincodeController, 'Pincode',
                        isNumeric: true, maxLength: 6),
                    _buildTextField(_mobileNumberController, 'Mobile Number',
                        isNumeric: true),
                    SizedBox(height: 20),

                    // Payment Method Section
                    Text('Payment Method',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Select Payment Method'),
                      value: _selectedPaymentMethod,
                      items: _getPaymentMethods(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                        _saveData();
                      },
                    ),
                    SizedBox(height: 20),

                    // Cart Items Section
                    Text('Cart Items:',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, index) {
                          final item = cart.items[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle:
                                Text('\₹${item.price.toStringAsFixed(2)} '),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Total: \₹${cart.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_validateInputs()) {
                            try {
                              final newOrder = Order(
                                id: DateTime.now().toString(),
                                totalAmount: cart.totalAmount,
                                address:
                                    '${_addressLine1Controller.text}, ${_cityController.text}, '
                                    '${_selectedState ?? ''}, ${_pincodeController.text}',
                                paymentMethod:
                                    _selectedPaymentMethod ?? 'Not Specified',
                                date: DateTime.now(),
                                items: cart.items,
                              );

                              orderProvider.addOrder(newOrder);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Order Placed ...'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              cart.clear();
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('An error occurred: $e'),
                              ));
                            }
                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Place Order',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getStates() {
    return <String>[
      'Andhra Pradesh',
      'Arunachal Pradesh',
      'Assam',
      'Bihar',
      'Chhattisgarh',
      'Goa',
      'Gujarat',
      'Haryana',
      'Himachal Pradesh',
      'Jharkhand',
      'Karnataka',
      'Kerala',
      'Madhya Pradesh',
      'Maharashtra',
      'Manipur',
      'Meghalaya',
      'Mizoram',
      'Nagaland',
      'Odisha',
      'Punjab',
      'Rajasthan',
      'Sikkim',
      'Tamil Nadu',
      'Telangana',
      'Tripura',
      'Uttar Pradesh',
      'Uttarakhand',
      'West Bengal',
      'Andaman and Nicobar Islands',
      'Chandigarh',
      'Dadra and Nagar Haveli and Daman and Diu',
      'Lakshadweep',
      'Delhi',
      'Puducherry',
      'Ladakh',
      'Jammu and Kashmir'
    ].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _getPaymentMethods() {
    return <String>['Cash on Delivery', 'UPI', 'Card Payment']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false, int maxLength = 20}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          labelText: label,
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => _saveData(),
      ),
    );
  }
}
