// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:provider/provider.dart';
import 'package:bubble_mobile/cache/feed_cache_provider.dart';
import 'package:bubble_mobile/data/models/bubble.dart';
import 'package:bubble_mobile/data/repositories/bubble_repository.dart';
import 'package:bubble_mobile/data/services/bubble_service.dart';
import 'package:bubble_mobile/presentation/components/buttons_feed_card.dart';
import 'package:flutter/material.dart';

class SavedFeedCard extends StatefulWidget {
  Bubble bubble;
  final VoidCallback refreshCallback;

  SavedFeedCard(this.bubble, {required this.refreshCallback, Key? key});

  @override
  State<SavedFeedCard> createState() => _SavedFeedCardState();
}

class _SavedFeedCardState extends State<SavedFeedCard> {
  BubbleService bubbleService = BubbleService();
  BubbleRepository bubbleRepository = BubbleRepository();

  @override
  Widget build(BuildContext context) {
    Bubble bubble = widget.bubble;

    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                bubbleService.imageProfile(bubble.imageSource),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bubbleService.plataformName(bubble.header),
                    bubbleService.datePost(bubble.datetime),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            bubbleService.description(bubble.description),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
            ),
            SizedBox(height: 10.0),
            ButtonsFeedCard(bubble.id!, handleBubbleFunction: removeBubble)
          ],
        ),
      ),
    );
  }

  Future<void> removeBubble() async {
    await bubbleRepository.deleteBubble(widget.bubble.id);
    Provider.of<FeedCacheProvider>(context, listen: false).toggleFeedState(widget.bubble.id!);
    widget.refreshCallback();
  }
  
}