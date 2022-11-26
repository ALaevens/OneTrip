import 'package:flutter/material.dart';
import 'package:one_trip/pages/profile_page/profile_page.dart';
import 'package:one_trip/pages/recipes_page/recipes_page.dart';
import 'package:one_trip/pages/themetest.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;
  late List<Widget> _pages;
  final List<String> _pageNames = [
    "Shopping List",
    "Saved Recipes",
    "Your Profile",
    "Color Debug"
  ];

  @override
  void initState() {
    _pages = <Widget>[
      Container(),
      const RecipesPage(),
      const ProfilePage(),
      const ColorPage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedPage]),
      appBar: AppBar(title: Text(_pageNames[_selectedPage])),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
            label: "List",
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: "Recipes",
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: "Profile",
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.grid_3x3),
            label: "Colors",
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          )
        ],
        currentIndex: _selectedPage,
        onTap: (value) {
          setState(() {
            _selectedPage = value;
          });
        },
      ),
    );
  }
}
