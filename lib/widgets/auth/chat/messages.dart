import 'package:chat_application/widgets/auth/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        // This automatically listens to chat collections and when new data comes
        // It will automatically notify our app and new data will be rendered
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Checking weather we dont have data or it is empty list
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong ...'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;
          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 10, left: 13, right: 13),
              // To take our messages at bottom
              reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMessages[index].data();
                final nextChatMessage = (index + 1 < loadedMessages.length)
                    ? loadedMessages[index + 1].data()
                    : null;

                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId = nextChatMessage != null
                    ? nextChatMessage['userId']
                    : null;

                final nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == currentMessageUserId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['userImage'],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == currentMessageUserId);
                }
              });
        });
  }
}
