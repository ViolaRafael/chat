import 'dart:async';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_message.dart';
import '../../models/chat_user.dart';

class ChatFirebaseService implements ChatService {
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        ).orderBy('createdAt', descending: true)
        .snapshots();


    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });

    ///versão mais explicita do codigo acima
    // return Stream<List<ChatMessage>>.multi((controller) {
    //   snapshots.listen((snapshot) {
    //     List<ChatMessage> list = snapshot.docs.map((doc) {
    //       return doc.data();
    //     }).toList();
    //       controller.add(list);
    //   });
    // });
  }

  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    );

    final docRef = await store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .add(msg);

    final doc = await docRef.get();
    return doc.data()!;
  }

  /// transforms ChatMessage into a dynamic map with Strings
  Map<String, dynamic> _toFirestore(
    ChatMessage msg,
    SetOptions? options,
  ) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageURL': msg.userImageURL,
    };
  }

  /// transforms dynamic map with strings into ChatMessage
  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageURL: doc['userImageURL'],
    );
  }
}
