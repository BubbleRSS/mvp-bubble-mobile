import 'package:bubble_mobile/presentation/components/appBar.dart';
import 'package:bubble_mobile/presentation/pages/feed.dart';
import 'package:bubble_mobile/presentation/pages/flavors.dart';
import 'package:bubble_mobile/presentation/pages/saved_feeds.dart';
import 'package:bubble_mobile/presentation/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.amber.withOpacity(0.5),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Obx(
          () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home', selectedIcon: Icon(Icons.home),),
              NavigationDestination(icon: Icon(Icons.local_cafe_outlined), label: 'Flavors', selectedIcon: Icon(Icons.local_cafe)),
              NavigationDestination(icon: Icon(Icons.favorite_outline), label: 'Save', selectedIcon: Icon(Icons.favorite)),
              NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Config', selectedIcon: Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const FeedPage(),
    ListFlavorAndTeasPage(),
    const SavedFeedsPage(),
    const SettingsPage()
  ];
}
