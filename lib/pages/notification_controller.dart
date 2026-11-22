import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafez_controller/state/hafez_controller_provider.dart';

class NotificationControllerPage extends ConsumerStatefulWidget {
  const NotificationControllerPage({super.key});

  @override
  ConsumerState<NotificationControllerPage> createState() =>
      _NotificationControllerPageState();
}

class _NotificationControllerPageState
    extends ConsumerState<NotificationControllerPage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> _tabs = [
    Tab(text: 'ارسال'),
    Tab(text: 'کنترل'),
  ];

  late final TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _groupIdController = TextEditingController(text: '2');
  int _selectedGroupId = 2;
  bool _isUrgent = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _groupIdController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    final desc = _bodyController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('متن اعلان نمی‌تواند خالی باشد')),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _sending = true);
    final err = await ref.read(hafezControllerProvider.notifier).sendNotification(
          title: _titleController.text.trim(),
          description: desc,
          groupId: _selectedGroupId,
          urgent: _isUrgent,
        );
    setState(() => _sending = false);

    if (!mounted) return;
    if (err == null) {
      _bodyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isUrgent ? 'اعلان اضطراری روی نمایشگر ارسال شد' : 'اعلان با موفقیت ارسال شد')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _controlTicker(String action) async {
    HapticFeedback.lightImpact();
    final groupVal = _groupIdController.text.trim();
    final err = await ref.read(hafezControllerProvider.notifier).sendCommand(
          target: 'notification',
          action: action,
          value: action == 'play' && groupVal.isNotEmpty ? groupVal : null,
        );
    if (!mounted || err == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hafezControllerProvider);
    final groups = state.notificationGroups;
    final isPlaying = state.liveState.isNotificationPlaying;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (groups.isNotEmpty) ...[
                      DropdownButtonFormField<int>(
                        value: groups.any((g) => g.id == _selectedGroupId)
                            ? _selectedGroupId
                            : groups.first.id,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'گروه اعلان',
                        ),
                        items: groups
                            .map((g) => DropdownMenuItem(value: g.id, child: Text(g.name)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _selectedGroupId = v;
                              _groupIdController.text = v.toString();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                    ],
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'عنوان اعلان',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _bodyController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'متن اعلان',
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('اعلان اضطراری فوری'),
                      subtitle: const Text('نمایش فوری (مانند جابه‌جایی خودرو یا اشیای پیداشده)'),
                      value: _isUrgent,
                      onChanged: (v) => setState(() => _isUrgent = v),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: _sending ? null : _sendNotification,
                      icon: Icon(_isUrgent ? Icons.warning_amber : Icons.send),
                      label: Text(_isUrgent ? 'ارسال فوری اضطراری' : 'ارسال به نمایشگر'),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          iconSize: 48,
                          onPressed: () => _controlTicker(isPlaying ? 'stop' : 'play'),
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                        const SizedBox(width: 32),
                        IconButton.filledTonal(
                          iconSize: 44,
                          onPressed: () => _controlTicker('stop'),
                          icon: const Icon(Icons.stop),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(isPlaying ? 'زیرنویس اعلانات در حال پخش است' : 'زیرنویس متوقف است'),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _groupIdController,
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'شماره گروه اعلان',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
