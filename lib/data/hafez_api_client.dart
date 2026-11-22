import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/signalr_client.dart';
import 'package:hafez_controller/data/models.dart';

class HafezApiClient {
  HubConnection? _hubConnection;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<bool> checkHealth(String host, int port) async {
    final uri = Uri.parse('http://$host:$port/api/health');
    final response = await http.get(uri).timeout(const Duration(seconds: 4));
    return response.statusCode == 200;
  }

  Future<HafezConnectionConfig> login({
    required String host,
    required int port,
    required String userId,
    required String password,
  }) async {
    final uri = Uri.parse('http://$host:$port/api/auth/login');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'userId': userId, 'password': password}),
        )
        .timeout(const Duration(seconds: 6));

    if (response.statusCode != 200) {
      throw Exception('نام کاربری یا رمز عبور اشتباه است (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return HafezConnectionConfig(
      host: host,
      port: port,
      token: (data['token'] ?? data['Token']).toString(),
      serverName: (data['name'] ?? data['Name'] ?? 'حافظ').toString(),
    );
  }

  Future<HafezLiveState> fetchState(HafezConnectionConfig config) async {
    final response = await http
        .get(Uri.parse('${config.baseUrl}/api/state'), headers: _headers(config.token))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode != 200) {
      throw Exception('خطا در دریافت وضعیت (${response.statusCode})');
    }
    return HafezLiveState.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<SureItem>> fetchSurahs(HafezConnectionConfig config) async {
    final response = await http
        .get(Uri.parse('${config.baseUrl}/api/catalog/surahs'), headers: _headers(config.token))
        .timeout(const Duration(seconds: 6));
    if (response.statusCode != 200) return [];
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => SureItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<DuaItem>> fetchMafatih(HafezConnectionConfig config) async {
    final response = await http
        .get(Uri.parse('${config.baseUrl}/api/catalog/mafatih'), headers: _headers(config.token))
        .timeout(const Duration(seconds: 6));
    if (response.statusCode != 200) return [];
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => DuaItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<DuaItem>> fetchPersonalDuas(HafezConnectionConfig config) async {
    final response = await http
        .get(Uri.parse('${config.baseUrl}/api/catalog/personal-duas'), headers: _headers(config.token))
        .timeout(const Duration(seconds: 6));
    if (response.statusCode != 200) return [];
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => DuaItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<NotificationGroupItem>> fetchNotificationGroups(HafezConnectionConfig config) async {
    final response = await http
        .get(Uri.parse('${config.baseUrl}/api/catalog/notification-groups'), headers: _headers(config.token))
        .timeout(const Duration(seconds: 6));
    if (response.statusCode != 200) return [];
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => NotificationGroupItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<String>> fetchGalleryFolders(HafezConnectionConfig config) async {
    final response = await http
        .get(Uri.parse('${config.baseUrl}/api/catalog/gallery-folders'), headers: _headers(config.token))
        .timeout(const Duration(seconds: 6));
    if (response.statusCode != 200) return [];
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => e.toString()).toList();
  }

  Future<HafezLiveState> sendCommand(
    HafezConnectionConfig config, {
    required String target,
    required String action,
    String? value,
    String? secondaryValue,
  }) async {
    final response = await http
        .post(
          Uri.parse('${config.baseUrl}/api/commands'),
          headers: _headers(config.token),
          body: jsonEncode({
            'target': target,
            'action': action,
            'value': value,
            'secondaryValue': secondaryValue,
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception('اجرای فرمان با خطا مواجه شد (${response.statusCode})');
    }

    return HafezLiveState.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> sendNotification(
    HafezConnectionConfig config, {
    required String title,
    required String description,
    int groupId = 2,
    bool urgent = false,
  }) async {
    final response = await http
        .post(
          Uri.parse('${config.baseUrl}/api/notifications/send'),
          headers: _headers(config.token),
          body: jsonEncode({
            'title': title,
            'description': description,
            'groupId': groupId,
            'urgent': urgent,
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception('ارسال اعلان با خطا مواجه شد (${response.statusCode})');
    }
  }

  Future<void> connectSignalR(
    HafezConnectionConfig config, {
    required void Function(HafezLiveState state) onStateChanged,
    required void Function(ConnectionStatus status) onStatusChanged,
  }) async {
    await disconnectSignalR();

    final hub = HubConnectionBuilder()
        .withUrl(config.hubUrl)
        .withAutomaticReconnect()
        .build();

    hub.on('StateChanged', (args) {
      if (args != null && args.isNotEmpty && args.first is Map<String, dynamic>) {
        onStateChanged(HafezLiveState.fromJson(args.first as Map<String, dynamic>));
      }
    });

    hub.onreconnecting(({error}) => onStatusChanged(ConnectionStatus.connecting));
    hub.onreconnected(({connectionId}) => onStatusChanged(ConnectionStatus.connected));
    hub.onclose(({error}) => onStatusChanged(ConnectionStatus.disconnected));

    _hubConnection = hub;
    await hub.start();
    onStatusChanged(ConnectionStatus.connected);
  }

  Future<void> disconnectSignalR() async {
    final hub = _hubConnection;
    _hubConnection = null;
    if (hub != null) {
      try {
        await hub.stop();
      } catch (_) {}
    }
  }
}
