// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedCard extends StatefulWidget {
  RssFeed? feeds;
  int index;

  FeedCard(this.feeds, this.index, {Key? key});

  @override
  State<FeedCard> createState() => FeedCardState();
}

class FeedCardState extends State<FeedCard> {
  bool openInBrowserClicked = false;
  bool shareClicked = false;
  bool likeClicked = false;

  @override
  Widget build(BuildContext context) {
    RssFeed? feeds = widget.feeds;
    int index = widget.index;

    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (feeds != null || feeds?.items != null) ...{
              Row(
                children: [
                  imageProfile(feeds?.image?.url),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      plataformName(feeds?.title),
                      datePost(feeds?.items?[index].pubDate),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              description(feeds?.items?[index].title),
              SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAlias,
                // child: thumbnail(feeds?.items?[index].description)
              ),
              SizedBox(height: 10.0),
              cardButtons()
            } else ...{ 
              CircularProgressIndicator()
            },
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
      plataformName ?? '',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  datePost(datePost) {
    if (datePost != null) {
      return Text(
        calculateDatePost(datePost),
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    } else {
      return 'Unknown';
    }
  }

  calculateDatePost (datePost) {
    timeago.setLocaleMessages('pt_br', timeago.PtBrMessages());
    return '${timeago.format(
      datePost, 
      locale: 'pt_br'
    )}';
  }

  imageProfile (image) {
    return CircleAvatar(
      radius: 20.0,
      backgroundImage: NetworkImage("https://pbs.twimg.com/profile_images/1389411778916978698/kA7uods9_400x400.jpg"),
    );
  }

  description (description) {
    return Linkify(
      onOpen: openLink,
      text: description ?? '',
      style: TextStyle(fontSize: 16),
      linkStyle: TextStyle(color: Colors.blue),
    );
  }

  Widget thumbnail(String? description) {
    String? imageFeed = extractImageUrl(description);

    if (imageFeed == null || imageFeed.isEmpty) {
      return Container(
        height: 200.0,
        width: double.infinity,
        color: Colors.grey,
        child: Center(child: Icon(Icons.broken_image, size: 50.0)),
      );
    } else {
      return Image.network(
        imageFeed,
        height: 200.0,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200.0,
            width: double.infinity,
            color: Colors.grey,
            child: Center(child: Icon(Icons.broken_image, size: 50.0)),
          );
        },
      );
    }
  }

  void openLink(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  String? extractImageUrl(String? description) {
    if (description == null) return null;

    var document = html_parser.parse(description);
    var imgTags = document.getElementsByTagName('img');

    if (imgTags.isNotEmpty) {
      return imgTags.first.attributes['src'];
    }

    return null;
  }

}