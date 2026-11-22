import 'package:flutter_test/flutter_test.dart';
import 'package:hafez_controller/data/models.dart';

void main() {
  test('HafezConnectionConfig parses valid QR JSON payload', () {
    const qr = '{"Host":"192.168.1.42","Port":5050,"Token":"secret123","Name":"مسجد حافظ"}';
    final cfg = HafezConnectionConfig.fromQrJson(qr);

    expect(cfg, isNotNull);
    expect(cfg!.host, '192.168.1.42');
    expect(cfg.port, 5050);
    expect(cfg.token, 'secret123');
    expect(cfg.serverName, 'مسجد حافظ');
    expect(cfg.baseUrl, 'http://192.168.1.42:5050');
  });

  test('HafezConnectionConfig rejects malformed QR payload', () {
    expect(HafezConnectionConfig.fromQrJson('not json'), isNull);
    expect(HafezConnectionConfig.fromQrJson('{"Host":""}'), isNull);
  });

  test('HafezLiveState parses server state JSON', () {
    final state = HafezLiveState.fromJson({
      'isNotificationPlaying': true,
      'isCameraActive': true,
      'activeQuranPage': 128,
      'connectedClients': 2,
    });

    expect(state.isNotificationPlaying, isTrue);
    expect(state.isCameraActive, isTrue);
    expect(state.activeQuranPage, 128);
    expect(state.connectedClients, 2);
  });
}
