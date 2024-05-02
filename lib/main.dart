import 'package:flutter/material.dart';
import 'login_page.dart';
import 'consumer_registration_page.dart';
import 'supplier_registration_page.dart';
import 'user_type_selection_page.dart';
import 'consumer/homepage.dart';
import 'consumer/orders.dart';
import 'consumer/favorites.dart';
import 'consumer/messages.dart';
import 'consumer/settings.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/user_type': (context) => UserTypeSelectionPage(),
      '/register_consumer': (context) => ConsumerRegistrationPage(),
      '/register_supplier': (context) => SupplierRegistrationPage(),
      '/home': (context) => ConsumerHomePage(),
      '/my_orders': (context) => MyOrdersScreen(),
      '/my_favorites': (context) => MyFavoritesScreen(),
      '/messages': (context) => MessagesScreen(),
      '/account_settings': (context) => AccountSettingsScreen(),
    },
  ));
}
