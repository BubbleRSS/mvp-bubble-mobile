import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.layers_outlined,
    Icons.chrome_reader_mode,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Pagina ${_selectedIndex + 1}'),
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.black,
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _icons.asMap().entries.map((entry) {
                final index = entry.key;
                final icon = entry.value;
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  icon: Icon(
                    icon,
                    color: _selectedIndex == index ? Colors.orange : Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
