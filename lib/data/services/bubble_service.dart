// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations
import 'package:bubble_mobile/data/models/bubble.dart';
import 'package:bubble_mobile/data/repositories/bubble_repository.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class BubbleService { 
  BubbleRepository bubbleRepository = BubbleRepository();

  Future<void> saveOrDeleteBubble (dynamic feed) async {
    Bubble bubble = Bubble(
      id: feed['id'],
      teaId: 0, 
      header: feed['title'], 
      description: feed['description'], 
      imageSource: feed['image'], 
      datetime: feed['pubDate'].toString(),
      link: feed['link']
    );

    List<Bubble> listBubbles = await bubbleRepository.getBubbles();

    if (listBubbles.isEmpty) {
        await bubbleRepository.insertBubble(bubble);
    } else {
      for (int i = 0; i < listBubbles.length; i++) {
        if (listBubbles[i].id == feed['id']) {
          bubbleRepository.deleteBubble(feed['id']);
          break;
        } else {
          if (i == listBubbles.length - 1) {
            await bubbleRepository.insertBubble(bubble);
            break;
          }
        }
      }
    }
    
  }

  Widget plataformName (plataformName) {
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
      datePost is String ? DateTime.parse(datePost) : datePost, 
      locale: 'pt_br'
    )}';
  }

  Widget imageProfile (image) {
    return CircleAvatar(
      radius: 20.0,
      backgroundImage: NetworkImage("https://pbs.twimg.com/profile_images/1389411778916978698/kA7uods9_400x400.jpg"),
    );
  }

  Widget description (description) {
    return Linkify(
      onOpen: openLink,
      text: description ?? '',
      style: TextStyle(fontSize: 16),
      linkStyle: TextStyle(color: Colors.blue),
    );
  }

  void openLink(dynamic link) async {
    if (link is LinkableElement && await canLaunch(link.url)) {
      await launch(link.url);
    } else if (link is String && await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

}