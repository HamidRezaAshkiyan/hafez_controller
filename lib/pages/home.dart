import 'package:hafez_controller/pages/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'کنترل حافظ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        // backgroundColor: Colors.orange,
        fixedColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.view_compact),
            label: "اعلانات",
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: "دوربین",
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: "گالری",
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "دعا",
          ),
        ],
      ),
      body: MyTabbedPage(),
    );
  }
}

class GalleryController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
              child: TextField(
                maxLength: 5,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'شماره پوشه تصاویر',
                ),
              ),
            ),
          ),
          // SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(iconSize: 50,
                  color: Colors.orange, onPressed: () {}, icon: Icon(Icons.skip_next)),
              IconButton(iconSize: 50,
                  color: Colors.orange, onPressed: () {}, icon: Icon(Icons.play_arrow)),
              IconButton(iconSize: 50,
                  color: Colors.orange, onPressed: () {}, icon: Icon(Icons.skip_previous))
            ],
          ),
        ],
      ),
    );
  }
}


class CameraController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Row(
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
              SizedBox(width: 100,),
              IconButton(
                iconSize: 50,
                onPressed: () {},
                icon: Icon(
                  Icons.stop,
                  color: Colors.orange,
                ),
              ),
            ],
          )),
    );
  }
}




class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset('assets/images/Hafez.png'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'خانه',
            ),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'تنظیمات',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'درباره ما',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text(
              'بازخورد',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'خارج شدن',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
