import 'package:alls_recorder/fullscreen_qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends StatelessWidget {
  final String userId;

  const QRPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: QrImageView.withQr(
                    qr: QrCode.fromData(
                        data: "ALLSID,$userId,114514", errorCorrectLevel: QrErrorCorrectLevel.L),
                    size: 200),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRPageFullscreen(userId: userId)),
              );
            }
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('复制成功'),
                  ),
                );
                Clipboard.setData(ClipboardData(text: userId));
              },
              child: Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text('你的 ALLS ID'),
                        Text(userId,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
