import 'package:bubble_mobile/presentation/components/appBar.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:bubble_mobile/api/feed.api.dart';
import 'package:bubble_mobile/presentation/components/feed_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  RssFeed? feeds;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  final FeedApiState feedApiState = FeedApiState();

  Future<void> loadFeeds() async {
    await feedApiState.getFeeds().then((result) {
      if (null != result || result.toString().isNotEmpty) {
        setState(() {
          feeds = result;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    loadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBarPage(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: feeds?.items?.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                FeedCard(feeds, index),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}