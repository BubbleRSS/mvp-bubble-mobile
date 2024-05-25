import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

class FeedApi extends StatefulWidget {
  const FeedApi({super.key});

  @override
  State<FeedApi> createState() => FeedApiState();
}

class FeedApiState extends State<FeedApi> {
  static const String feedUrl = 'https://nitter.poast.org/geekversez/rss';
  final Xml2Json xml2json = Xml2Json();

  Future<List> getFeeds() async {
    try {
      const feedUrl = 'https://nitter.poast.org/geekversez/rss';

      final response = await http.get(Uri.parse(feedUrl));
      xml2json.parse(response.body);

      var feedData = xml2json.toParker();
      var data = json.decode(feedData);
      List feeds = data['rss']['channel']['item'];
      print('RSS feed: $feeds');

      return feeds ?? [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}