import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  UploadPage({
    super.key,
    required this.userImage,
    required this.feedData,
    required this.addFeedData,
  });
  final XFile? userImage;
  final List feedData;
  final Function(Map) addFeedData;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("새 게시글"),
        actions: [
          IconButton(
            onPressed: () {
              widget.addFeedData({
                'id': widget.feedData.length,
                'image': widget.userImage,
                'likes': 0,
                'date': DateTime.now().toString(),
                'content': content,
                'user': 'user1234',
              });
              Navigator.pop(context);
            },
            icon: Icon(Icons.send_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.userImage != null
              ? Image.file(File(widget.userImage!.path))
              : Text('no image'),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              maxLines: 5,
              decoration: InputDecoration(hintText: '내용을 입력해주세요.'),
              onChanged: (value) => setState(() => content = value),
            ),
          ),
        ],
      ),
    );
  }
}
