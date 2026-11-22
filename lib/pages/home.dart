import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_controller/pages/book_controller.dart';
import 'package:hafez_controller/pages/notification_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    NotificationControllerPage(),
    CameraControllerPage(),
    GalleryControllerPage(),
    BookControllerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'کنترل حافظ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'اعلانات',
          ),
          NavigationDestination(
            icon: Icon(Icons.videocam_outlined),
            selectedIcon: Icon(Icons.videocam),
            label: 'دوربین',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'گالری',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'دعا و قرآن',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}

class GalleryControllerPage extends StatefulWidget {
  const GalleryControllerPage({super.key});

  @override
  State<GalleryControllerPage> createState() => _GalleryControllerPageState();
}

class _GalleryControllerPageState extends State<GalleryControllerPage> {
  final TextEditingController _folderController = TextEditingController();

  @override
  void dispose() {
    _folderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          TextField(
            controller: _folderController,
            maxLength: 5,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'شماره پوشه تصاویر',
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filledTonal(
                iconSize: 40,
                onPressed: () {},
                icon: const Icon(Icons.skip_previous),
              ),
              IconButton.filled(
                iconSize: 52,
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
              ),
              IconButton.filledTonal(
                iconSize: 40,
                onPressed: () {},
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CameraControllerPage extends StatelessWidget {
  const CameraControllerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            label: const Text('شروع دوربین'),
          ),
          const SizedBox(width: 24),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.stop),
            label: const Text('توقف دوربین'),
          ),
        ],
      ),
    );
  }
}

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset('assets/images/Hafez.png'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('خانه'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('تنظیمات'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('درباره ما'),
              onTap: () {
                Navigator.of(context).pop();
                showAboutDialog(
                  context: context,
                  applicationName: 'کنترل حافظ',
                  applicationVersion: '2.0.0',
                  applicationLegalese: 'MIT License — Hafez Project',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
