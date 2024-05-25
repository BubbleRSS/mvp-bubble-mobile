// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedCard extends StatefulWidget {
  final List feed;
  final int index;

  FeedCard(this.feed, this.index, {Key? key});

  @override
  State<FeedCard> createState() => FeedCardState();
}

class FeedCardState extends State<FeedCard> {
  bool openInBrowserClicked = false;
  bool shareClicked = false;
  bool likeClicked = false;

  @override
  Widget build(BuildContext context) {
    List feed = widget.feed;
    int index = widget.index;

    // print("INDEX FEED: $feed[index]");

    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // imageProfile(feed[index]['image']['url']),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // plataformName(feed[index]['title']),
                    datePost(feed[index]['pubDate']),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            description(feed[index]['description']),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
              // child: thumbnail(feed[index]['enclosure']['url'])
            ),
            SizedBox(height: 10.0),
            cardButtons()
          ],
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

  plataformName (plataformName) {
    return Text(
      plataformName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  datePost(String datePost) {
    DateTime parsedDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", "en_US").parseUTC(datePost);
    print("DATA: $parsedDate");
    return Text(
      calculateDatePost(parsedDate),
      style: TextStyle(
        color: Colors.grey,
      ),
    );
  }

  calculateDatePost (datePost) {
    timeago.setLocaleMessages('pt_br', timeago.PtBrMessages());
    return '${timeago.format(
      datePost, 
      locale: 'pt_br'
    )}';
  }

  imageProfile (imageProfile) {
    return CircleAvatar(
      radius: 20.0,
      backgroundImage: NetworkImage('$imageProfile'),
    );
  }

  description (description) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  thumbnail (image) {
    return Image.network(
      '$image',
      height: 200.0,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

}