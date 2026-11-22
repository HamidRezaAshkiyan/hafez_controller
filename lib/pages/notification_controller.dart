import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationControllerPage extends StatefulWidget {
  const NotificationControllerPage({super.key});

  @override
  State<NotificationControllerPage> createState() =>
      _NotificationControllerPageState();
}

class _NotificationControllerPageState extends State<NotificationControllerPage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> _tabs = [
    Tab(text: 'ارسال'),
    Tab(text: 'کنترل'),
  ];

  late final TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _groupIdController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'عنوان اعلان',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bodyController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'متن اعلان',
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send),
                      label: const Text('ارسال به نمایشگر'),
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
                          iconSize: 44,
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                        ),
                        const SizedBox(width: 32),
                        IconButton.filledTonal(
                          iconSize: 44,
                          onPressed: () {},
                          icon: const Icon(Icons.pause),
                        ),
                      ],
                    ),
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
