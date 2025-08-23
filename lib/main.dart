import 'package:flutter/material.dart';
import 'style.dart' as styleTheme;
import 'pages/home.dart';
import 'pages/shop.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), theme: styleTheme.theme));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentTab = 'home';

  final Map<String, Widget> _pages = {'home': HomePage(), 'shop': ShopPage()};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram', textAlign: TextAlign.left),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add_box_outlined)),
        ],
      ),
      body: _pages[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: () {
          if (_currentTab == 'home') return 0;
          if (_currentTab == 'shop') return 1;
          return 0;
        }(),
        onTap: (index) {
          setState(() {
            if (index == 0) _currentTab = 'home';
            if (index == 1) _currentTab = 'shop';
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'shop',
          ),
        ],
      ),
    );
  }
}
