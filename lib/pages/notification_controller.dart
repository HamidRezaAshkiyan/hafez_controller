import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({ Key? key }) : super(key: key);
  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}


class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'ارسال'),
    Tab(text: 'کنترل'),
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
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                SizedBox(height: 50,),
                Center(
                  child: Container(
                    width: 200,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'متن',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    // style: ButtonStyle(backgroundColor: ),
                      onPressed: () {},
                      child: Text('ارسال')
                  ),
                )
              ],
            ),
          ),
          NotificationController(),
        ],
      ),
    );
  }
}

class NotificationController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 50,
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  IconButton(
                    iconSize: 50,
                    onPressed: () {},
                    icon: Icon(
                      Icons.pause,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Center(
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
              )
            ],
          )),
    );
  }
}
