import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafez_controller/state/hafez_controller_provider.dart';

class BookControllerPage extends ConsumerStatefulWidget {
  const BookControllerPage({super.key});

  @override
  ConsumerState<BookControllerPage> createState() => _BookControllerPageState();
}

class _BookControllerPageState extends ConsumerState<BookControllerPage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> _tabs = [
    Tab(text: 'قرآن'),
    Tab(text: 'مفاتیح'),
    Tab(text: 'اختصاصی'),
  ];

  late final TabController _tabController;
  final TextEditingController _pageController = TextEditingController(text: '1');
  int? _selectedSurahId;
  int? _selectedMafatihId;
  int? _selectedPersonalDuaId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _send(String target, String action, {String? value}) async {
    HapticFeedback.lightImpact();
    final err = await ref.read(hafezControllerProvider.notifier).sendCommand(
          target: target,
          action: action,
          value: value,
        );
    if (!mounted || err == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hafezControllerProvider);

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
                    if (state.surahs.isNotEmpty) ...[
                      DropdownButtonFormField<int>(
                        value: _selectedSurahId ?? state.surahs.first.id,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'انتخاب سوره',
                        ),
                        items: state.surahs
                            .map((s) => DropdownMenuItem(value: s.id, child: Text('${s.id}. ${s.name}')))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedSurahId = v);
                          if (v != null) {
                            _send('quran', 'select', value: v.toString());
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pageController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'شماره صفحه (۱ تا ۶۰۴)',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.tonal(
                          onPressed: () => _send('quran', 'select', value: _pageController.text.trim()),
                          child: const Text('برو به صفحه'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    BookTransportControls(
                      isPlaying: state.liveState.isQuranPlaying,
                      onPrevious: () => _send('quran', 'previous'),
                      onPlayPause: () => _send('quran', state.liveState.isQuranPlaying ? 'stop' : 'play'),
                      onReset: () => _send('quran', 'reset'),
                      onNext: () => _send('quran', 'next'),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.mafatih.isNotEmpty) ...[
                      DropdownButtonFormField<int>(
                        value: _selectedMafatihId ?? state.mafatih.first.id,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'انتخاب دعا از مفاتیح‌الجنان',
                        ),
                        items: state.mafatih
                            .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name)))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedMafatihId = v);
                          if (v != null) _send('mafatih', 'select', value: v.toString());
                        },
                      ),
                      const SizedBox(height: 28),
                    ],
                    BookTransportControls(
                      isPlaying: state.liveState.isMafatihPlaying,
                      onPrevious: () => _send('mafatih', 'previous'),
                      onPlayPause: () => _send('mafatih', state.liveState.isMafatihPlaying ? 'stop' : 'play'),
                      onReset: () => _send('mafatih', 'reset'),
                      onNext: () => _send('mafatih', 'next'),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.personalDuas.isNotEmpty) ...[
                      DropdownButtonFormField<int>(
                        value: _selectedPersonalDuaId ?? state.personalDuas.first.id,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'انتخاب دعای اختصاصی',
                        ),
                        items: state.personalDuas
                            .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name)))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedPersonalDuaId = v);
                          if (v != null) _send('personaldua', 'select', value: v.toString());
                        },
                      ),
                      const SizedBox(height: 28),
                    ],
                    BookTransportControls(
                      isPlaying: state.liveState.isPersonalDuaPlaying,
                      onPrevious: () => _send('personaldua', 'previous'),
                      onPlayPause: () =>
                          _send('personaldua', state.liveState.isPersonalDuaPlaying ? 'stop' : 'play'),
                      onReset: () => _send('personaldua', 'reset'),
                      onNext: () => _send('personaldua', 'next'),
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

class BookTransportControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onNext;

  const BookTransportControls({
    super.key,
    required this.isPlaying,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onReset,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        IconButton.filledTonal(
          iconSize: 36,
          onPressed: onPrevious,
          icon: const Icon(Icons.skip_previous_outlined),
        ),
        IconButton.filled(
          iconSize: 52,
          onPressed: onPlayPause,
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
        ),
        IconButton.filledTonal(
          iconSize: 44,
          onPressed: onReset,
          icon: const Icon(Icons.restart_alt_outlined),
        ),
        IconButton.filledTonal(
          iconSize: 36,
          onPressed: onNext,
          icon: const Icon(Icons.skip_next_outlined),
        ),
      ],
    );
  }
}
