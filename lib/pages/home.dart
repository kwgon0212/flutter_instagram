import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.data, required this.setFeedData});
  final List data;
  final Function(List) setFeedData;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var more = 1;
  var feedScroll = ScrollController();

  Future<void> fetchFeedData() async {
    final result = await http.get(
      Uri.parse('https://codingapple1.github.io/app/data.json'),
    );
    setState(() => widget.setFeedData(jsonDecode(result.body)));
  }

  Future<void> fetchMore() async {
    try {
      final result = await http.get(
        Uri.parse('https://codingapple1.github.io/app/more$more.json'),
      );
      setState(
        () => widget.setFeedData([...widget.data, jsonDecode(result.body)]),
      );
      more++;
    } catch (e) {
      feedScroll.removeListener(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFeedData();
    feedScroll.addListener(() async {
      if (feedScroll.position.pixels == feedScroll.position.maxScrollExtent) {
        await fetchMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: feedScroll,
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return CardItem(item: widget.data[index]);
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
          item['image'].runtimeType == String
              ? Image.network(
                  item['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 300,
                )
              : Image.file(
                  File(item['image'].path),
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
