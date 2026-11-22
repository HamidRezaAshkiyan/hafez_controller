import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookControllerPage extends StatefulWidget {
  const BookControllerPage({super.key});

  @override
  State<BookControllerPage> createState() => _BookControllerPageState();
}

class _BookControllerPageState extends State<BookControllerPage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> _tabs = [
    Tab(text: 'قرآن'),
    Tab(text: 'مفاتیح'),
    Tab(text: 'اختصاصی'),
  ];

  late final TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _pageController.dispose();
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'عنوان سوره',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _pageController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'شماره صفحه',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const BookTransportControls(),
                  ],
                ),
              ),
              const Center(child: BookTransportControls()),
              const Center(child: BookTransportControls()),
            ],
          ),
        ),
      ],
    );
  }
}

class BookTransportControls extends StatelessWidget {
  const BookTransportControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        IconButton.filledTonal(
          iconSize: 36,
          onPressed: () {},
          icon: const Icon(Icons.skip_previous_outlined),
        ),
        IconButton.filled(
          iconSize: 52,
          onPressed: () {},
          icon: const Icon(Icons.play_arrow),
        ),
        IconButton.filledTonal(
          iconSize: 44,
          onPressed: () {},
          icon: const Icon(Icons.restart_alt_outlined),
        ),
        IconButton.filledTonal(
          iconSize: 36,
          onPressed: () {},
          icon: const Icon(Icons.skip_next_outlined),
        ),
      ],
    );
  }
}
