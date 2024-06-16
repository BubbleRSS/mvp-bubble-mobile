// ignore_for_file: prefer_const_constructors, must_be_immutable, dead_code
import 'package:provider/provider.dart';
import 'package:bubble_mobile/cache/feed_cache_provider.dart';
import 'package:flutter/material.dart';

class ButtonsFeedCard extends StatefulWidget {
  int index;
  Function handleBubbleFunction;

  ButtonsFeedCard(this.index, {required this.handleBubbleFunction, Key? key});

  @override
  State<ButtonsFeedCard> createState() => _ButtonsFeedCardState();
}

class _ButtonsFeedCardState extends State<ButtonsFeedCard> {
  @override
  Widget build(BuildContext context) {
    bool defaultIcon = false;
    bool likeClicked = Provider.of<FeedCacheProvider>(context, listen: false).getFeedState(widget.index);

    return Row(
      children: [
          Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                defaultIcon = !defaultIcon;
              });
            },
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
            onPressed: () {
              setState(() {
                defaultIcon = !defaultIcon;
              });
            },
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

  Future<void> handleBubble() async {
    widget.handleBubbleFunction();
  }

}