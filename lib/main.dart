import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'loading_screen.dart';
import 'consumer_registration_page.dart';
import 'supplier_registration_page.dart';
import 'user_type_selection_page.dart';
import 'consumer/homepage.dart';
import 'consumer/orders.dart';
import 'consumer/favorites.dart';
import 'consumer/messages.dart';
import 'consumer/settings.dart';
import 'provider/user_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that plugin services are initialized
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(), // Initialize EasyLoading
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
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
    );
  }
}
