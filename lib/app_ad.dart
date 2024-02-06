import 'package:alls_recorder/ios_hint.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppAd extends StatelessWidget {
  const AppAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Text('下载 ALLS Go 客户端以获得更流畅的体验'),
                const Spacer(),
                IconButton(
                    onPressed: onPressedAndroid, icon: const Icon(Icons.android)),
                IconButton(
                    onPressed: () => onPressedIOS(context), icon: const Icon(Icons.apple))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onPressedAndroid() async {
    var url = "https://www.pgyer.com/alls-recorder";
    if (await canLaunchUrlString(url)) {
      launchUrlString(url);
    }
  }

  Future<void> onPressedIOS(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IosHintPage(),
      ),
    );
  }
}
