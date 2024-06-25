// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations
import 'package:bubble_mobile/data/repositories/bubble_repository.dart';
import 'package:bubble_mobile/presentation/components/saved_feed_card.dart';
import 'package:bubble_mobile/data/models/bubble.dart';
import 'package:flutter/material.dart';

class SavedFeedsPage extends StatefulWidget {
  const SavedFeedsPage({super.key});

  @override
  State<SavedFeedsPage> createState() => _SavedFeedsPageState();
}

class _SavedFeedsPageState extends State<SavedFeedsPage> {
  BubbleRepository bubbleRepository = BubbleRepository();
  List<Bubble> savedBubbles = [];

  @override
  void initState() {
    super.initState();
    loadSavedBubbles();
  }

  void loadSavedBubbles() {
    bubbleRepository.getBubbles().then((bubbles) {
      setState(() {
        savedBubbles = bubbles;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: loadSavedFeeds()
      )
    );
  }

  Widget loadSavedFeeds () {
    if (savedBubbles != null && savedBubbles.length > 0) {
      return ListView.builder(
        itemCount: savedBubbles.length,
        itemBuilder: (BuildContext context, int index) {
          Bubble bubble = savedBubbles[index];
          return Column(
            children: [
              SavedFeedCard(bubble, refreshCallback: loadSavedBubbles),
              SizedBox(height: 10),
            ],
          );
        },
      );
    }

    return Center(
      child: Text('Não há posts salvos')
    );
  }
  
}