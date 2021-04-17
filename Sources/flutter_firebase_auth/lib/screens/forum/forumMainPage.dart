import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionTab.dart';
import 'package:flutter_firebase_auth/screens/forum/newDiscussionPage.dart';
import 'package:flutter_firebase_auth/screens/forum/promotionTab.dart';

class ForumMainPage extends StatefulWidget {

  @override
  _ForumMainPageState createState() => _ForumMainPageState();
}

class _ForumMainPageState extends State<ForumMainPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int selectedTab = 0;

  void setSelectedTab(int newSelectedTab) {
    setState(() {
      this.selectedTab = newSelectedTab;
    });
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTab = _tabController.index;
      });
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50.0,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Discussion',
                /*icon: Icon(Icons.info_outline),*/
              ),
              Tab(text: 'Promotion',
                  /*icon: Icon(Icons.monetization_on_outlined)*/
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "newForumThread",
          icon: Icon(Icons.add_circle_outline_outlined),
          label: selectedTab == 0 ? Text("New discussion") : Text("New promotion"),
          onPressed: () {
            if(selectedTab == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewDiscussionPage())
              );
            }
            else {
              print("TODO NEW PROMOTION");
            }
          },
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DiscussionTab(),
            PromotionTab(),
          ],
        ),
    );
  }
}
