// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedCard extends StatefulWidget {
  final Map<String, dynamic> feed;

  FeedCard(this.feed, {Key? key});

  @override
  State<FeedCard> createState() => FeedCardState();
}

class FeedCardState extends State<FeedCard> {
  bool openInBrowserClicked = false;
  bool shareClicked = false;
  bool likeClicked = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> feed = widget.feed;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage('${feed['plataformImage']}'),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feed['plataformName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        calculateDatePost(feed['datePostFeed']),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                feed['description'] ?? '',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  '${feed['plataformImage']}',
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10.0),
              cardButtons()
            ],
          ),
        ),
      ),
    );
  }

  Row cardButtons() {
    return Row(
      children: [
          Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                openInBrowserClicked = !openInBrowserClicked;
              });
            },
            icon: openInBrowserClicked ? Icon(Icons.open_in_new) : Icon(Icons.open_in_new),
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
            onPressed: () {
              setState(() {
                likeClicked = !likeClicked;
              });
            },
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
                shareClicked = !shareClicked;
              });
            },
            icon: shareClicked ? Icon(Icons.share_rounded) : Icon(Icons.share_outlined),
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

  String calculateDatePost (String feed) {
    timeago.setLocaleMessages('pt_br', timeago.PtBrMessages());
    final DateTime datePostFeed = DateTime.parse(feed);
    return '${timeago.format(
      datePostFeed, 
      locale: 'pt_br'
    )}';
  }

}