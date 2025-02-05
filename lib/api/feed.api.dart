import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class FeedApi extends StatefulWidget {
  const FeedApi({super.key});

  @override
  State<FeedApi> createState() => FeedApiState();
}

class FeedApiState extends State<FeedApi> {
  static const String feedUrl = 'https://nitter.poast.org/geekversez/rss';

  Future<RssFeed?> getFeeds() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(feedUrl));
      return RssFeed.parse(response.body);
    } catch (e) {
      print('Ocorreu um erro ao fazer requisição: $e');
    }

    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}