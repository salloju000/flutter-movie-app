import 'package:flutter/material.dart';
import 'package:assignment_app/screens/home_screen.dart';
import 'package:assignment_app/screens/search_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
  ];

  void _onIconTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 80,
            child: Container(
              width: 160,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color:
                          _currentIndex == 0 ? Colors.blueAccent : Colors.white,
                    ),
                    onPressed: () => _onIconTap(0),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color:
                          _currentIndex == 1 ? Colors.blueAccent : Colors.white,
                    ),
                    onPressed: () => _onIconTap(1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
