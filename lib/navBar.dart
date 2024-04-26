import 'package:bubble_mobile/home.dart';
import 'package:bubble_mobile/teas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: NavBar(),
  ));
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TeasScreen(),
  ];
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      extendBody: true,
      bottomNavigationBar:  Container(
          decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20),
            border: Border( top: BorderSide(color: Colors.amber, width: 3, style: BorderStyle.solid),)  
          ),
          child: 
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            unselectedItemColor: Colors.white.withOpacity(.60),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'Teas',
                icon: Icon(Icons.layers),
              ),
              BottomNavigationBarItem(
                label: 'Saves',
                icon: Icon(Icons.chrome_reader_mode),
              ),
              BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        )
      );
  }
}
