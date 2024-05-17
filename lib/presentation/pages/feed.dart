import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bubble_mobile/presentation/components/feed_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> arrayFeeds = [];
    List<Map<String, dynamic>> plataformImage = [];

    DateTime randomDate() {
      final random = Random();
      final start = DateTime(2020, 1, 1);
      final end = DateTime.now();
      return start.add(Duration(seconds: random.nextInt(end.difference(start).inSeconds)));
    }

    for (int i = 0; i < 10; i++) {
      plataformImage.add({
        'plataformaImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTQHWj5HOXAdgW3Hn0K-qXOAnut5k-jk4J1__UundkUiQEIAAyMZ92QtcaTZnJm5-ZJVU&usqp=CAU'
      });
    }

    for (int i = 0; i < 10; i++) {
      arrayFeeds.add({
        'plataformImage': plataformImage[i]['plataformaImage'],
        'plataformName': 'Plataforma ${i + 1}',
        'datePostFeed': randomDate().toString(),
        'plataformSite': 'http://plataforma${i + 1}.com',
        'description': 'Descrição do feed ${i + 1}',
        'feedImage': 'feed_${i + 1}.jpg',
      });
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
        itemCount: arrayFeeds.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              FeedCard(arrayFeeds[index]),
              const SizedBox(height: 10)
            ],
          );
        },
      ),
      )
    );
  }
}