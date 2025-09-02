import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_instagram/pages/home/profile.dart';

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

  void _onScroll() async {
    if (feedScroll.position.pixels == feedScroll.position.maxScrollExtent) {
      await fetchMore();
    }
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
      feedScroll.removeListener(_onScroll);
      feedScroll.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    feedScroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    feedScroll.removeListener(_onScroll);
    feedScroll.dispose();
    super.dispose();
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
          (item['isLocal'] == true && File(item['image']).existsSync())
              ? Image.file(
                  File(item['image']),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 300,
                )
              : (item['isLocal'] == true)
              ? SizedBox(
                  height: 300,
                  child: Center(child: Icon(Icons.broken_image)),
                )
              : CachedNetworkImage(
                  imageUrl: item['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 300,
                  placeholder: (context, url) => SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => SizedBox(
                    height: 300,
                    child: Center(child: Icon(Icons.broken_image)),
                  ),
                ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProfilePage(user: item['id']),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                // FadeTransition(
                                //   opacity: animation,
                                //   child: child,
                                // ),
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(-1, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                        transitionDuration: Duration(milliseconds: 300),
                      ),
                    );
                  },
                  child: Text(
                    '${item['id'] ?? 'unknown'}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
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
