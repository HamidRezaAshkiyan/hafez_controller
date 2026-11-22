import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hafez_controller/state/hafez_controller_provider.dart';

class QrScannerPage extends ConsumerStatefulWidget {
  const QrScannerPage({super.key});

  @override
  ConsumerState<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends ConsumerState<QrScannerPage> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اسکن کد QR حافظ')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              if (_handled) return;
              final barcode = capture.barcodes.firstOrNull;
              final raw = barcode?.rawValue;
              if (raw == null || raw.isEmpty) return;

              _handled = true;
              final ok = await ref.read(hafezControllerProvider.notifier).pairFromQrJson(raw);
              if (!context.mounted) return;

              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اتصال به سرور حافظ با موفقیت برقرار شد')),
                );
                Navigator.of(context).pop();
              } else {
                _handled = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('کد QR نامعتبر است یا سرور در دسترس نیست')),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: Colors.black54,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'در نرم‌افزار ویندوز حافظ کلید Ctrl+Q را بزنید و کد QR را اسکن کنید',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
