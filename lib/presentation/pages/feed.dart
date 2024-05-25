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
  late List feeds = [];
  late GlobalKey<RefreshIndicatorState> refreshKey;
  final FeedApiState feedApiState = FeedApiState();

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    loadFeed();
  }

  Future<void> loadFeed() async {
    List result = await feedApiState.getFeeds();
    setState(() {
      feeds = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: feeds.length,
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