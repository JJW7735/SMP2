import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smp_chat/screens/login_screen.dart'; // 로그인 화면 import
import 'package:cloud_firestore/cloud_firestore.dart';

class ChattingScreen extends StatefulWidget {
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final _controller = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    final user = _auth.currentUser;
    if (user != null && _controller.text.isNotEmpty) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists && userData.data() != null && userData.data()!.containsKey('username')) {
        _firestore.collection('chats').add({
          'text': _controller.text,
          'createdAt': Timestamp.now(),
          'username': userData['username'],
          'userId': user.uid,
        });
        _controller.clear();
      } else {
        print('Error: User document does not exist or has no data.');
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
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

                if (!chatSnapshot.hasData) {
                  return Center(child: Text('No messages yet.'));
                }

                final chatDocs = chatSnapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    final chatData = chatDocs[index].data() as Map<String, dynamic>;
                    final username = chatData.containsKey('username')
                        ? chatData['username']
                        : 'Unknown User';

                    return ListTile(
                      title: Text(chatData['text']),
                      subtitle: Text(username),
                    );
                  },
                );
              },
            ),
          ),
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
