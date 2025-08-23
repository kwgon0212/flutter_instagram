import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];

  Future<void> fetchFeedData() async {
    final result = await http.get(
      Uri.parse('https://codingapple1.github.io/app/data.json'),
    );
    setState(() => data = jsonDecode(result.body));
  }

  @override
  void initState() {
    super.initState();
    fetchFeedData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return CardItem(item: data[index]);
      },
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.item});
  final Map item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            item['image'],
            width: double.infinity,
            fit: BoxFit.cover,
            height: 300,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '좋아요 ${item['likes']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${item['date']}', style: TextStyle(fontSize: 12)),
                Text('${item['content']}', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
