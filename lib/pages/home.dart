import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafez_controller/data/models.dart';
import 'package:hafez_controller/pages/book_controller.dart';
import 'package:hafez_controller/pages/notification_controller.dart';
import 'package:hafez_controller/pages/qr_scanner_page.dart';
import 'package:hafez_controller/pages/settings_page.dart';
import 'package:hafez_controller/state/hafez_controller_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    NotificationControllerPage(),
    CameraControllerPage(),
    GalleryControllerPage(),
    BookControllerPage(),
  ];

  Color _statusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return Colors.green;
      case ConnectionStatus.connecting:
        return Colors.amber;
      case ConnectionStatus.error:
        return Colors.red;
      case ConnectionStatus.disconnected:
        return Colors.grey;
    }
  }

  String _statusLabel(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return 'متصل';
      case ConnectionStatus.connecting:
        return 'اتصال...';
      case ConnectionStatus.error:
        return 'خطا';
      case ConnectionStatus.disconnected:
        return 'آفلاین';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hafezControllerProvider);

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              state.config?.serverName ?? 'کنترل حافظ',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _statusColor(state.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _statusLabel(state.status),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'اسکن QR',
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QrScannerPage()),
              );
            },
          ),
          IconButton(
            tooltip: 'تنظیمات',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          HapticFeedback.selectionClick();
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

class GalleryControllerPage extends ConsumerStatefulWidget {
  const GalleryControllerPage({super.key});

  @override
  ConsumerState<GalleryControllerPage> createState() => _GalleryControllerPageState();
}

class _GalleryControllerPageState extends ConsumerState<GalleryControllerPage> {
  final TextEditingController _folderController = TextEditingController();
  String? _selectedFolder;

  @override
  void dispose() {
    _folderController.dispose();
    super.dispose();
  }

  Future<void> _dispatch(String action) async {
    HapticFeedback.lightImpact();
    final folder = _selectedFolder ?? _folderController.text.trim();
    final err = await ref.read(hafezControllerProvider.notifier).sendCommand(
          target: 'gallery',
          action: action,
          value: folder.isEmpty ? null : folder,
        );
    if (!mounted || err == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hafezControllerProvider);
    final folders = state.galleryFolders;
    final isPlaying = state.liveState.isGalleryPlaying;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          if (folders.isNotEmpty)
            DropdownButtonFormField<String>(
              value: _selectedFolder ?? folders.first,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'انتخاب پوشه گالری',
              ),
              items: folders
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedFolder = v),
            )
          else
            TextField(
              controller: _folderController,
              maxLength: 20,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'نام یا شماره پوشه تصاویر',
              ),
            ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filledTonal(
                iconSize: 40,
                onPressed: () => _dispatch('previous'),
                icon: const Icon(Icons.skip_previous),
              ),
              IconButton.filled(
                iconSize: 52,
                onPressed: () => _dispatch(isPlaying ? 'stop' : 'play'),
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              IconButton.filledTonal(
                iconSize: 40,
                onPressed: () => _dispatch('next'),
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CameraControllerPage extends ConsumerWidget {
  const CameraControllerPage({super.key});

  Future<void> _send(BuildContext context, WidgetRef ref, String action) async {
    HapticFeedback.lightImpact();
    final err = await ref.read(hafezControllerProvider.notifier).sendCommand(
          target: 'camera',
          action: action,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err ?? (action == 'start' ? 'دوربین فعال شد' : 'دوربین متوقف شد'))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(hafezControllerProvider.select((s) => s.liveState.isCameraActive));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.videocam : Icons.videocam_off_outlined,
              size: 72,
              color: isActive ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              isActive ? 'پخش زنده دوربین فعال است' : 'دوربین خاموش است',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () => _send(context, ref, 'start'),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('شروع دوربین'),
                ),
                const SizedBox(width: 20),
                OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('توقف پخش زنده'),
                        content: const Text('آیا مطمئن هستید که می‌خواهید دوربین زنده را متوقف کنید؟'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('انصراف')),
                          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('توقف')),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      await _send(context, ref, 'stop');
                    }
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('توقف دوربین'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(hafezControllerProvider.select((s) => s.themeMode == ThemeMode.dark));

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
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('اسکن کد QR اتصال'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const QrScannerPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('تنظیمات و اتصال'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('حالت شب'),
              value: isDark,
              onChanged: (v) => ref.read(hafezControllerProvider.notifier).toggleDarkMode(v),
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
