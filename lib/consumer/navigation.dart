import 'package:flutter/material.dart';

class ConsumerLayout extends StatelessWidget {
  final Widget child;
  final String username; // Username to display in the drawer header

  ConsumerLayout({required this.child, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumer Homepage'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('My Orders'),
              onTap: () {
                Navigator.pushNamed(context, '/my_orders');
              },
            ),
            ListTile(
              title: Text('My Favorites'),
              onTap: () {
                Navigator.pushNamed(context, '/my_favorites');
              },
            ),
            ListTile(
              title: Text('Messages'),
              onTap: () {
                Navigator.pushNamed(context, '/messages');
              },
            ),
            ListTile(
              title: Text('Account Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/account_settings');
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
