import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class FeedApi extends StatefulWidget {
  const FeedApi({super.key});

  @override
  State<FeedApi> createState() => FeedApiState();
}

class FeedApiState extends State<FeedApi> {
  String feedUrl = '';

  @override
  void initState() {
    super.initState();
    feedUrl = ApiFeed().getFeedUrl() != '' ? ApiFeed().getFeedUrl() : 'https://nitter.poast.org/geekversez/rss';
  }

  Future<RssFeed?> getFeeds() async {
    try {
      feedUrl = ApiFeed().getFeedUrl() != '' ? ApiFeed().getFeedUrl() : 'https://nitter.poast.org/geekversez/rss';
      final client = http.Client();
      final response = await client.get(
        Uri.parse(feedUrl),
        headers: { 
          HttpHeaders.accessControlAllowOriginHeader: "*"
        }
      );
      return RssFeed.parse(response.body);
    } catch (e) {
      print('Ocorreu um erro ao fazer requisição: $e');
    }

    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ApiFeed {
  static final ApiFeed _instance = ApiFeed._internal();

  String feedUrl = '';

  factory ApiFeed() {
    return _instance;
  }

  ApiFeed._internal();

  void updateFeedUrl(String newFeedUrl) {
    feedUrl = newFeedUrl;
  }

  String getFeedUrl() {
    return feedUrl;
  }
}