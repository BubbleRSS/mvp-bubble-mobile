// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, must_be_immutable
import 'package:bubble_mobile/data/repositories/bubble_repository.dart';
import 'package:bubble_mobile/data/services/bubble_service.dart';
import 'package:bubble_mobile/presentation/components/buttons_feed_card.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  List<Map<String, dynamic>> feedStateProps;
  int index;
  final Function refreshCallback;

  FeedCard(this.feedStateProps, this.index, {required this.refreshCallback, Key? key});

  @override
  State<FeedCard> createState() => FeedCardState();
}

class FeedCardState extends State<FeedCard> {
  BubbleService bubbleService = BubbleService();
  BubbleRepository bubbleRepository = BubbleRepository();
  
  late bool likeClicked;
  late Map<String, dynamic> feed;

  @override
  Widget build(BuildContext context) {
    setState(() {
      likeClicked = widget.feedStateProps[widget.index]['state'];
      widget.feedStateProps[widget.index]['id'] = widget.index;
      feed = widget.feedStateProps[widget.index];
    });

    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                bubbleService.imageProfile(feed['image']),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bubbleService.plataformName(feed['title']),
                    bubbleService.datePost(feed['pubDate']),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            bubbleService.description(feed['description']),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
            ),
            SizedBox(height: 10.0),
            ButtonsFeedCard(feed, widget.index, handleBubbleFunction: handleBubble)
          ],
        ),
      ),
    );
  }

  Future<void> handleBubble () async {
    await bubbleService.saveOrDeleteBubble(feed);
    widget.refreshCallback(widget.index);
  }

}