import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('As Minhas Notificações'),
      ),
      body: const Center(
        child: Text('Notificações'),
      ),
    );
  }
}
