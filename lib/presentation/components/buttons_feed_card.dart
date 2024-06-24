// ignore_for_file: prefer_const_constructors, must_be_immutable, dead_code
import 'package:bubble_mobile/data/services/bubble_service.dart';
import 'package:provider/provider.dart';
import 'package:bubble_mobile/cache/feed_cache_provider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ButtonsFeedCard extends StatefulWidget {
  late Map<String, dynamic> feed;
  int index;
  Function handleBubbleFunction;

  ButtonsFeedCard(this.feed, this.index, {required this.handleBubbleFunction, Key? key});

  @override
  State<ButtonsFeedCard> createState() => _ButtonsFeedCardState();
}

class _ButtonsFeedCardState extends State<ButtonsFeedCard> {
  BubbleService bubbleService = BubbleService();


  @override
  Widget build(BuildContext context) {
    bool defaultIcon = false;
    bool likeClicked = Provider.of<FeedCacheProvider>(context, listen: false).getFeedState(widget.index);

    return Row(
      children: [
          Expanded(
          child: ElevatedButton.icon(
            onPressed: () => openLinkFeed(defaultIcon),
            icon: defaultIcon ? Icon(Icons.open_in_new) : Icon(Icons.open_in_new),
            label: Text(''),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(10.0),
                  bottomStart: Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(15.0),
            ),
          ),                  
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => handleBubble(),
            icon: likeClicked ? Icon(Icons.favorite_rounded) : Icon(Icons.favorite_outline_rounded),
            label: Text(''),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(0.0),
                  bottomEnd: Radius.circular(0.0),
                ),
              ),
              padding: EdgeInsets.all(15.0),
            ),
          ),
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Share.share(widget.feed['link']),
            icon: defaultIcon ? Icon(Icons.share_rounded) : Icon(Icons.share_outlined),
            label: Text(''),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10.0),
                  bottomEnd: Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(15.0),
            ),
          ),                  
        ),
      ],
    );
  }

  void openLinkFeed (bool state) {
    setState(() {
      state = !state;
    });

    bubbleService.openLink(widget.feed['link']);
  }

  Future<void> handleBubble() async {
    widget.handleBubbleFunction();
  }

}