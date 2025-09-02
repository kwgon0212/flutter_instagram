import 'package:flutter/material.dart';
import 'style.dart' as style_theme;
import 'pages/home.dart';
import 'pages/shop.dart';
import 'pages/home/upload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> _saveFeedsToLocal(List feeds) async {
    final prefs = await SharedPreferences.getInstance();
    // 네트워크 이미지/로컬 이미지 모두 문자열로 저장
    await prefs.setString('feeds', jsonEncode(feeds));
  }

  Future<void> _loadFeedsFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('feeds');
    if (raw == null) return;
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      setState(() => feedData = decoded);
    }
  }

  void setFeedData(List newFeedData) {
    setState(() => feedData = newFeedData);
    _saveFeedsToLocal(newFeedData);
  }

  void addFeedData(Map newFeed) {
    setState(() => feedData.insert(0, newFeed));
    _saveFeedsToLocal(feedData);
  }

  @override
  void initState() {
    super.initState();
    _bootstrapFeeds();
  }

  Future<void> _bootstrapFeeds() async {
    await _loadFeedsFromLocal();
    if (feedData.isEmpty) {
      try {
        final result = await http.get(
          Uri.parse('https://codingapple1.github.io/app/data.json'),
        );
        final decoded = jsonDecode(result.body);
        if (decoded is List) {
          setFeedData(decoded);
        }
      } catch (_) {
        // 네트워크 실패 시 조용히 무시 (로컬만 사용)
      }
    }
  }

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
