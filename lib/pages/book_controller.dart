import 'package:flutter/material.dart';

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({ Key? key }) : super(key: key);
  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}


class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'قرآن'),
    Tab(text: 'مفاتیح'),
    Tab(text: 'اختصاصی'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
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
        toolbarHeight: 60,
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column( // Quran Container
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  Center(
                    child: Container(
                      width: 200,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'عنوان',
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'شماره صفحه',
                        ),
                      ),
                    ),
                  )
                ],
              ),
              BookController(),
            ],
          ),
          BookController(),
          BookController(),
        ],
      ),
    );
  }
}

class BookController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Center(
                child: Container(
                  width: 200,
                  child: TextField(
                    maxLength: 5,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'شماره گروه اعلان',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    iconSize: 50,
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_next_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  IconButton(
                    iconSize: 80,
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_circle_outline_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  // SizedBox(width: 100),
                  IconButton(
                    iconSize: 80,
                    onPressed: () {},
                    icon: Icon(
                      Icons.restart_alt_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  // SizedBox(width: 100),
                  IconButton(
                    iconSize: 50,
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_previous_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  // SizedBox(width: 100),
                ],
              )
            ],
          )),
    );
  }
}
