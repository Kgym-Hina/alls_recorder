import 'dart:convert';
import 'dart:io';

import 'package:alls_recorder/app_ad.dart';
import 'package:alls_recorder/model/video.dart';
import 'package:alls_recorder/qr_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcade Live Linkage System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Arcade Live Linkage System'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getUserId() async {
    // 读取本地存储的用户ID
    final userId = await SharedPreferences.getInstance()
        .then((value) => value.getString('userId'));
    if (userId != null) {
      return userId;
    }

    // 本地没有存储用户ID，生成一个
    var newGeneratedUserId = Uuid().v4();
    await SharedPreferences.getInstance()
        .then((value) => value.setString('userId', newGeneratedUserId));
    return newGeneratedUserId;
  }

  var _selectedIndex = 0;

  Widget getQRPage() {
    return FutureBuilder<String>(
      future: getUserId(), // 异步操作
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // 根据快照的状态返回不同的UI
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 如果还在等待，显示一个进度指示器
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 如果出错，显示错误
        } else {
          return QRPage(userId: snapshot.data!); // 如果完成，显示QRPage
        }
      },
    );
  }

  Widget getVideosListPage() {
    return FutureBuilder<String>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error getting ID: ${snapshot.error}');
        } else {
          return FutureBuilder<List<Video>>(
            future: fetchVideos(snapshot.data!),
            builder: (context, snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot2.hasError) {
                return Text('Error: ${snapshot2.error}');
              } else {
                return VideoList(videos: snapshot2.data!);
              }
            },
          );
        }
      },
    );
  }

  Widget getAd() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return const SizedBox();
      } else {
        return const AppAd();
      }
    } catch (e) {
      return const AppAd();
    }
  }

  Future<List<Video>> fetchVideos(String userId) async {
    debugPrint('https://alls-api.genso-system.ink/all?id=$userId');

    final response = await http
        .get(Uri.parse('https://alls-api.genso-system.ink/all?id=$userId'));

    debugPrint(response.body);

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var result = list.map((video) => Video.fromJson(video)).toList();
      // 返回倒序排列的视频列表
      return result.reversed.toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            getAd(),
            Expanded(child: _selectedIndex == 0 ? getQRPage() : getVideosListPage())
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: '个人二维码',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_file),
              label: '视频列表',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}
