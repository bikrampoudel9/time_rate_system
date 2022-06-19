import 'package:flutter/material.dart';
import 'package:tractor/Home.dart';
import 'package:tractor/Settings.dart';
import 'package:tractor/ViewDetails.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Time management",
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  int _selectedIndex = 1;

  PageController? _pageController;

  List<Widget>? tabs = [Settings(), Home(), ViewDetails()];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _pageController = PageController(initialPage: _selectedIndex);

    return Scaffold(
      
      body: PageView(
        controller: _pageController,
        children: tabs!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController!.jumpToPage(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_view),
            label: "Transaction",
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
