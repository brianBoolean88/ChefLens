import "package:flutter/material.dart";

import "../widgets/top_app_bar.dart";

import "../screens/home_page.dart";
import "../screens/staff_directory_page.dart";

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  static const List<Widget> screens = <Widget>[
    HomePage(),
    StaffDirectoryPage(),
    Card(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text("Add Page"),
      ),
    ),
    Card(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text("Profile Page"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).colorScheme;
    final PageController controller = PageController(initialPage: 0);

    return Scaffold(
      appBar: const MyAppBar(),
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: controller,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo),
              label: "Add",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: appColorScheme.primary,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            controller.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
