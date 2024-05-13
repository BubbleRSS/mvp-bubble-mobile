// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bubble_mobile/presentation/components/feed.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
      body: ListView.builder(
        itemCount: arrayFeeds.length,
        itemBuilder: (BuildContext context, int index) {
          return Feed(arrayFeeds[index]);
        },
      ),
    );
  }
}
