import 'package:flutter/material.dart';
import 'style.dart' as style_theme;
import 'pages/home.dart';
import 'pages/shop.dart';
import 'pages/home/upload.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), theme: style_theme.theme));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentTab = 'home';
  List feedData = [];
  XFile? userImage;

  void setFeedData(List newFeedData) => setState(() => feedData = newFeedData);
  void addFeedData(Map newFeed) => setState(() => feedData.insert(0, newFeed));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram', textAlign: TextAlign.left),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image == null) return;
              setState(() => userImage = image);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadPage(
                    userImage: userImage,
                    feedData: feedData,
                    addFeedData: addFeedData,
                  ),
                ),
              );
            },
            icon: Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: _currentTab == 'home'
          ? HomePage(data: feedData, setFeedData: setFeedData)
          : ShopPage(),
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
