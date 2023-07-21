import 'package:chat_application/widgets/auth/chat/messages.dart';
import 'package:chat_application/widgets/auth/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotifications() async{
    final fcm=FirebaseMessaging.instance;
     await fcm.requestPermission(); 
// This yields address of different devices and then send this address with an HTTP request
     final token= await fcm.getToken();
    //  This will be slightly slow bcz we are targeting entire channel
     fcm.subscribeToTopic('chat');
  }
  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('FlutterChat'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: Messages(),
          ),
          // Messages(),
          NewMessage(),
        ],
      ),
    );
  }
}
