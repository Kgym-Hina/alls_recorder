import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPageFullscreen extends StatelessWidget {
  final String userId;

  const QRPageFullscreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView.withQr(
                  qr: QrCode.fromData(
                      data: "ALLSID,$userId,114514", errorCorrectLevel: QrErrorCorrectLevel.L),
                  size: 500),
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),

    );
  }
}
