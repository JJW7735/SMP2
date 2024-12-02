import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChattingScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChattingScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // Firestore에 메시지 저장
      _firestore.collection('chats').add({
        'text': _controller.text,
        'createdAt': Timestamp.now(),
      });
      _controller.clear(); // 메시지 입력창 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Chat (Anonymous)'),
      ),
      body: Column(
        children: [
          // 메시지 리스트 표시
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final chatDocs = chatSnapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // 최신 메시지가 아래에 표시되도록 설정
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(chatDocs[index]['text']),
                    );
                  },
                );
              },
            ),
          ),
          // 메시지 입력창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Send a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}