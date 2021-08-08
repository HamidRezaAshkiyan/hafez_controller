
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        centerTitle: true,
        title: Text(
          'کنترل حافظ',
          style: TextStyle(fontFamily: 'Vazir', fontWeight: FontWeight.bold),
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
      body: Container(

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
                    SizedBox(width: 20,),
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
                SizedBox(height: 20,),
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
              // child: ,
            )),
      ),
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
