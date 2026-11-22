import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hafez_controller/data/hafez_api_client.dart';
import 'package:hafez_controller/data/models.dart';

class HafezControllerState {
  final ConnectionStatus status;
  final HafezConnectionConfig? config;
  final HafezLiveState liveState;
  final List<SureItem> surahs;
  final List<DuaItem> mafatih;
  final List<DuaItem> personalDuas;
  final List<NotificationGroupItem> notificationGroups;
  final List<String> galleryFolders;
  final ThemeMode themeMode;
  final String? lastError;

  const HafezControllerState({
    this.status = ConnectionStatus.disconnected,
    this.config,
    this.liveState = const HafezLiveState(),
    this.surahs = const [],
    this.mafatih = const [],
    this.personalDuas = const [],
    this.notificationGroups = const [],
    this.galleryFolders = const [],
    this.themeMode = ThemeMode.system,
    this.lastError,
  });

  HafezControllerState copyWith({
    ConnectionStatus? status,
    HafezConnectionConfig? config,
    bool clearConfig = false,
    HafezLiveState? liveState,
    List<SureItem>? surahs,
    List<DuaItem>? mafatih,
    List<DuaItem>? personalDuas,
    List<NotificationGroupItem>? notificationGroups,
    List<String>? galleryFolders,
    ThemeMode? themeMode,
    String? lastError,
    bool clearError = false,
  }) {
    return HafezControllerState(
      status: status ?? this.status,
      config: clearConfig ? null : (config ?? this.config),
      liveState: liveState ?? this.liveState,
      surahs: surahs ?? this.surahs,
      mafatih: mafatih ?? this.mafatih,
      personalDuas: personalDuas ?? this.personalDuas,
      notificationGroups: notificationGroups ?? this.notificationGroups,
      galleryFolders: galleryFolders ?? this.galleryFolders,
      themeMode: themeMode ?? this.themeMode,
      lastError: clearError ? null : (lastError ?? this.lastError),
    );
  }
}

class HafezControllerNotifier extends StateNotifier<HafezControllerState> {
  final HafezApiClient _api;

  HafezControllerNotifier(this._api) : super(const HafezControllerState()) {
    _restoreSavedSession();
  }

  Future<void> _restoreSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool('dark_mode');
    if (dark != null) {
      state = state.copyWith(themeMode: dark ? ThemeMode.dark : ThemeMode.light);
    }

    final host = prefs.getString('hafez_host') ?? '';
    final port = prefs.getInt('hafez_port') ?? 5050;
    final token = prefs.getString('hafez_token') ?? '';
    final name = prefs.getString('hafez_name') ?? 'حافظ';

    if (host.isNotEmpty && token.isNotEmpty) {
      await connectWithConfig(
        HafezConnectionConfig(host: host, port: port, token: token, serverName: name),
      );
    }
  }

  Future<void> toggleDarkMode(bool isDark) async {
    state = state.copyWith(themeMode: isDark ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
  }

  Future<bool> pairFromQrJson(String rawQr) async {
    final parsed = HafezConnectionConfig.fromQrJson(rawQr);
    if (parsed == null) {
      state = state.copyWith(lastError: 'کد QR معتبر نیست');
      return false;
    }
    return connectWithConfig(parsed);
  }

  Future<bool> loginAndConnect({
    required String host,
    required int port,
    required String userId,
    required String password,
  }) async {
    state = state.copyWith(status: ConnectionStatus.connecting, clearError: true);
    try {
      final config = await _api.login(host: host, port: port, userId: userId, password: password);
      return connectWithConfig(config);
    } catch (e) {
      state = state.copyWith(status: ConnectionStatus.error, lastError: e.toString());
      return false;
    }
  }

  Future<bool> connectWithConfig(HafezConnectionConfig config) async {
    state = state.copyWith(status: ConnectionStatus.connecting, config: config, clearError: true);
    try {
      final live = await _api.fetchState(config);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('hafez_host', config.host);
      await prefs.setInt('hafez_port', config.port);
      await prefs.setString('hafez_token', config.token);
      await prefs.setString('hafez_name', config.serverName);

      state = state.copyWith(status: ConnectionStatus.connected, liveState: live);

      await refreshCatalogs();
      await _api.connectSignalR(
        config,
        onStateChanged: (updated) => state = state.copyWith(liveState: updated),
        onStatusChanged: (s) => state = state.copyWith(status: s),
      );
      return true;
    } catch (e) {
      state = state.copyWith(status: ConnectionStatus.error, lastError: e.toString());
      return false;
    }
  }

  Future<void> refreshCatalogs() async {
    final config = state.config;
    if (config == null) return;

    try {
      final results = await Future.wait([
        _api.fetchSurahs(config),
        _api.fetchMafatih(config),
        _api.fetchPersonalDuas(config),
        _api.fetchNotificationGroups(config),
        _api.fetchGalleryFolders(config),
      ]);

      state = state.copyWith(
        surahs: results[0] as List<SureItem>,
        mafatih: results[1] as List<DuaItem>,
        personalDuas: results[2] as List<DuaItem>,
        notificationGroups: results[3] as List<NotificationGroupItem>,
        galleryFolders: results[4] as List<String>,
      );
    } catch (_) {}
  }

  Future<String?> sendCommand({
    required String target,
    required String action,
    String? value,
    String? secondaryValue,
  }) async {
    final config = state.config;
    if (config == null) {
      return 'ابتدا به سرور حافظ متصل شوید (بخش تنظیمات یا اسکن QR)';
    }

    try {
      final updated = await _api.sendCommand(
        config,
        target: target,
        action: action,
        value: value,
        secondaryValue: secondaryValue,
      );
      state = state.copyWith(liveState: updated, clearError: true);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> sendNotification({
    required String title,
    required String description,
    int groupId = 2,
    bool urgent = false,
  }) async {
    final config = state.config;
    if (config == null) {
      return 'ابتدا به سرور حافظ متصل شوید (بخش تنظیمات یا اسکن QR)';
    }

    try {
      await _api.sendNotification(
        config,
        title: title,
        description: description,
        groupId: groupId,
        urgent: urgent,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> disconnect() async {
    await _api.disconnectSignalR();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hafez_token');
    state = state.copyWith(status: ConnectionStatus.disconnected, clearConfig: true);
  }
}

final hafezApiClientProvider = Provider<HafezApiClient>((ref) => HafezApiClient());

final hafezControllerProvider =
    StateNotifierProvider<HafezControllerNotifier, HafezControllerState>(
  (ref) => HafezControllerNotifier(ref.read(hafezApiClientProvider)),
);
