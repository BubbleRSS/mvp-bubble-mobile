import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble_mobile/home.dart';
import 'package:bubble_mobile/teas.dart';

void main() {
  runApp(MaterialApp(
    home: NavBar(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amber,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
  ));
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TeasScreen(),
  ];

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
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.local_cafe), label: 'Teas'),
              NavigationDestination(icon: Icon(Icons.save), label: 'Save'),
              NavigationDestination(icon: Icon(Icons.settings), label: 'Config'),
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
    HomeScreen(),
    TeasScreen()
  ];
}
