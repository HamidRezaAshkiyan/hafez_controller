import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafez_controller/data/models.dart';
import 'package:hafez_controller/pages/qr_scanner_page.dart';
import 'package:hafez_controller/state/hafez_controller_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _hostController = TextEditingController(text: '192.168.1.10');
  final _portController = TextEditingController(text: '5050');
  final _userController = TextEditingController(text: 'admin');
  final _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cfg = ref.read(hafezControllerProvider).config;
    if (cfg != null) {
      _hostController.text = cfg.host;
      _portController.text = cfg.port.toString();
    }
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hafezControllerProvider);
    final notifier = ref.read(hafezControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات و اتصال')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QrScannerPage()),
              );
            },
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('اتصال سریع با اسکن کد QR'),
          ),
          const SizedBox(height: 24),
          const Text('اتصال دستی (نام کاربری و رمز عبور)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _hostController,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'آدرس IP سرور حافظ'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _portController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'پورت API (پیش‌فرض 5050)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _userController,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'شناسه کاربری'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passController,
            obscureText: true,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'رمز عبور'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: state.status == ConnectionStatus.connecting
                      ? null
                      : () async {
                          final ok = await notifier.loginAndConnect(
                            host: _hostController.text.trim(),
                            port: int.tryParse(_portController.text.trim()) ?? 5050,
                            userId: _userController.text.trim(),
                            password: _passController.text,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(ok ? 'متصل شد' : (ref.read(hafezControllerProvider).lastError ?? 'خطا در اتصال')),
                            ),
                          );
                        },
                  child: const Text('ورود و اتصال'),
                ),
              ),
              if (state.status == ConnectionStatus.connected) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => notifier.disconnect(),
                  child: const Text('قطع اتصال'),
                ),
              ],
            ],
          ),
          const Divider(height: 36),
          SwitchListTile(
            title: const Text('حالت شب (Dark Mode)'),
            subtitle: const Text('مناسب محیط کم‌نور مساجد'),
            value: state.themeMode == ThemeMode.dark,
            onChanged: (val) => notifier.toggleDarkMode(val),
          ),
        ],
      ),
    );
  }
}
