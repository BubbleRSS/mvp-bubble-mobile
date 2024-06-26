// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:math';
import 'package:bubble_mobile/presentation/components/appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble_mobile/cache/feed_cache_provider.dart';
import 'package:webfeed/webfeed.dart';
import 'package:bubble_mobile/api/feed.api.dart';
import 'package:bubble_mobile/presentation/components/feed_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  final FeedApiState feedApiState = FeedApiState();
  RssFeed? feeds;

  @override
  void initState() {
    super.initState();
    loadFeeds(context);
  }

  DateTime randomDate() {
    final random = Random();
    final start = DateTime(2024, DateTime.now().month, DateTime.now().day);
    final end = DateTime.now();
    return start.add(Duration(seconds: random.nextInt(end.difference(start).inSeconds)));
  }

  Future<void> loadFeeds(BuildContext context) async {
    await feedApiState.getFeeds().then((result) {
      if (result != null) {
        List<Map<String, dynamic>> feedStateProps = [];
        List<RssItem>? items = result.items;
        for (int i = 0; i < items!.length; i++) {
          feedStateProps.add({
            'id': null,
            'title': result.title,
            'pub_date': items[i].pubDate ?? randomDate(),
            'image_profile': result.image?.url ?? "",
            'image_source': items[i].enclosure?.url ?? 
                            (items[i].media?.contents != null && items[i].media!.contents!.isNotEmpty ? items[i].media!.contents![0].url : ''),
            'description': items[i].title,
            'link': items[i].link ?? items[i].guid ?? '',
            'state': Provider.of<FeedCacheProvider>(context, listen: false).getFeedState(i)
          });
        }
        Provider.of<FeedCacheProvider>(context, listen: false).setFeeds(feedStateProps);
      }
    });
  }

  void feedLikedStateProps (int index) {
    Provider.of<FeedCacheProvider>(context, listen: false).toggleFeedState(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBarPage(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Consumer<FeedCacheProvider>(
          builder: (context, feedProvider, child) {
            if (feedProvider.feedStateProps.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: feedProvider.feedStateProps.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    FeedCard(feedProvider.feedStateProps, index, refreshCallback: feedLikedStateProps),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );

          },
        ),
      ),
    );
  }

}