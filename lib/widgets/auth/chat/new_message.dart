import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = TextEditingController();

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    // add will dynamically add values to firestore and it will not have name of my choice like in set
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createAt': Timestamp.now(),
      'userId' : user.uid,
      'username' : userData.data()!['username'],
      'userImage' : userData.data()!['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Send a message...',
            ),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(
              Icons.send,
            ),
          )
        ],
      ),
    );
  }
}
