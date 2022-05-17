import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/model.dart';
import 'package:news_app/service/service.dart';
import 'package:news_app/widget/news_item.dart';

class TabBarMenu extends StatefulWidget {
  final List<Article> article;

  const TabBarMenu({Key? key, required this.article}) : super(key: key);

  @override
  State<TabBarMenu> createState() => _TabBarMenuState();
}

class _TabBarMenuState extends State<TabBarMenu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Tab> myTab = [
    const Tab(
      text: 'business',
    ),
    const Tab(
      text: 'entertainment',
    ),
    const Tab(
      text: 'general',
    ),
    const Tab(
      text: 'health',
    ),
    const Tab(
      text: 'science',
    ),
    const Tab(
      text: 'sports',
    ),
    const Tab(
      text: 'technology',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTab.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var news = News();

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: myTab,
            labelColor: Colors.deepOrangeAccent,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            indicator: const BubbleTabIndicator(
              indicatorHeight: 30.0,
              indicatorColor: Colors.black,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: myTab.map((Tab tab) {
                  return FutureBuilder(
                      future: news.getNewsByCategory(tab.text.toString()),
                      builder: (context, snapshot) => snapshot.data != null
                          ? _listNewsCategory(snapshot.data as List<Article>)
                          : Center(child: CircularProgressIndicator()));
                }).toList()),
          )
        ],
      ),
    );
  }

  Widget _listNewsCategory(List<Article> article) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListView.builder(
        itemBuilder: (context, index) => NewsItem(article: article[index]),
        itemCount: article.length,
      ),
    );
  }
}
