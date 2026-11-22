import 'dart:convert';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

class HafezConnectionConfig {
  final String host;
  final int port;
  final String token;
  final String serverName;

  const HafezConnectionConfig({
    required this.host,
    required this.port,
    required this.token,
    this.serverName = 'حافظ',
  });

  String get baseUrl => 'http://$host:$port';
  String get hubUrl => '$baseUrl/hub/hafez?access_token=$token';
  bool get isConfigured => host.isNotEmpty && port > 0 && token.isNotEmpty;

  static HafezConnectionConfig? fromQrJson(String raw) {
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final host = (decoded['Host'] ?? decoded['host'] ?? '').toString().trim();
      final portRaw = decoded['Port'] ?? decoded['port'] ?? 5050;
      final port = portRaw is int ? portRaw : int.tryParse(portRaw.toString()) ?? 5050;
      final token = (decoded['Token'] ?? decoded['token'] ?? '').toString().trim();
      final name = (decoded['Name'] ?? decoded['name'] ?? 'حافظ').toString();

      if (host.isEmpty || token.isEmpty) {
        return null;
      }

      return HafezConnectionConfig(
        host: host,
        port: port,
        token: token,
        serverName: name,
      );
    } catch (_) {
      return null;
    }
  }
}

class HafezLiveState {
  final bool isNotificationPlaying;
  final bool isQuranPlaying;
  final bool isMafatihPlaying;
  final bool isPersonalDuaPlaying;
  final bool isCameraActive;
  final bool isGalleryPlaying;
  final String activeNotificationText;
  final String activeQuranTitle;
  final int activeQuranPage;
  final String activeMafatihTitle;
  final String prayerBanner;
  final int connectedClients;

  const HafezLiveState({
    this.isNotificationPlaying = false,
    this.isQuranPlaying = false,
    this.isMafatihPlaying = false,
    this.isPersonalDuaPlaying = false,
    this.isCameraActive = false,
    this.isGalleryPlaying = false,
    this.activeNotificationText = '',
    this.activeQuranTitle = '',
    this.activeQuranPage = 1,
    this.activeMafatihTitle = '',
    this.prayerBanner = '',
    this.connectedClients = 0,
  });

  factory HafezLiveState.fromJson(Map<String, dynamic> json) {
    return HafezLiveState(
      isNotificationPlaying: (json['isNotificationPlaying'] ?? json['IsNotificationPlaying'] ?? false) as bool,
      isQuranPlaying: (json['isQuranPlaying'] ?? json['IsQuranPlaying'] ?? false) as bool,
      isMafatihPlaying: (json['isMafatihPlaying'] ?? json['IsMafatihPlaying'] ?? false) as bool,
      isPersonalDuaPlaying: (json['isPersonalDuaPlaying'] ?? json['IsPersonalDuaPlaying'] ?? false) as bool,
      isCameraActive: (json['isCameraActive'] ?? json['IsCameraActive'] ?? false) as bool,
      isGalleryPlaying: (json['isGalleryPlaying'] ?? json['IsGalleryPlaying'] ?? false) as bool,
      activeNotificationText: (json['activeNotificationText'] ?? json['ActiveNotificationText'] ?? '').toString(),
      activeQuranTitle: (json['activeQuranTitle'] ?? json['ActiveQuranTitle'] ?? '').toString(),
      activeQuranPage: (json['activeQuranPage'] ?? json['ActiveQuranPage'] ?? 1) as int,
      activeMafatihTitle: (json['activeMafatihTitle'] ?? json['ActiveMafatihTitle'] ?? '').toString(),
      prayerBanner: (json['prayerBanner'] ?? json['PrayerBanner'] ?? '').toString(),
      connectedClients: (json['connectedClients'] ?? json['ConnectedClients'] ?? 0) as int,
    );
  }
}

class SureItem {
  final int id;
  final String name;
  final int ayahCount;

  const SureItem({required this.id, required this.name, this.ayahCount = 0});

  factory SureItem.fromJson(Map<String, dynamic> json) {
    return SureItem(
      id: (json['id'] ?? json['ID'] ?? 0) as int,
      name: (json['suraName'] ?? json['SuraName'] ?? '').toString(),
      ayahCount: (json['ayahCount'] ?? json['AyahCount'] ?? 0) as int,
    );
  }
}

class DuaItem {
  final int id;
  final String name;

  const DuaItem({required this.id, required this.name});

  factory DuaItem.fromJson(Map<String, dynamic> json) {
    return DuaItem(
      id: (json['duaId'] ?? json['DuaId'] ?? 0) as int,
      name: (json['duaName'] ?? json['DuaName'] ?? '').toString(),
    );
  }
}

class NotificationGroupItem {
  final int id;
  final String name;

  const NotificationGroupItem({required this.id, required this.name});

  factory NotificationGroupItem.fromJson(Map<String, dynamic> json) {
    return NotificationGroupItem(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      name: (json['name'] ?? json['Name'] ?? '').toString(),
    );
  }
}
