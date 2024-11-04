import 'package:ecommerce_app/AccountPage.dart';
import 'package:ecommerce_app/AuthStateHandler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';
import 'login_screen.dart';
import 'order_history_screen.dart';
import 'order_provider.dart';
import 'product_list_screen.dart';
import 'profile_screen.dart';
import 'register_screen.dart';
import 'addproduct.dart';
import 'user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-commerce App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: AuthStateHandler(),
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegistrationScreen(),
          '/products': (context) => ProductListScreen(),
          '/cart': (context) => CartScreen(),
          '/checkout': (context) => CheckoutScreen(),
          '/orders': (context) => OrderHistoryScreen(),
          '/profile': (context) => ProfileScreen(),
          '/account': (context) => AccountPage(),
          '/add_products': (context) => AddProductsPage(
                onProductAdded: (Product) {},
              ),
        },
      ),
    );
  }
}
