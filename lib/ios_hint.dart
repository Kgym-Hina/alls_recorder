import 'package:flutter/material.dart';

class IosHintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iOS 使用 PWA 应用的方法'),
        // TODO: 上架 App Store
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('1. 使用 Safari 浏览器打开 https://alls.genso-system.ink'),
            SizedBox(height: 20),
            Text('2. 点击底部的分享按钮'),
            SizedBox(height: 20),
            Text('3. 点击「添加到主屏幕」'),
            SizedBox(height: 20),
            Text('4. 点击「添加」'),
            SizedBox(height: 20),
            Text('5. 点击主屏幕上的 ALLS Go 图标'),
          ],
        ),
      ),
    );
  }
}