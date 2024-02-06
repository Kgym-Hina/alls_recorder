import 'dart:io';

import 'package:alls_recorder/model/video.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VideoList extends StatefulWidget {
  final List<Video> videos;

  const VideoList({super.key, required this.videos});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final Map<int, double> _downloadProgress = {};

  Future<void> saveNetworkVideo(Video video) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        download(video);
      } else {
        throw Exception("不支持下载");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('不支持下载'),
        ),
      );
      if (await canLaunchUrlString(video.url)) {
        launchUrlString(video.url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('无法打开视频'),
          ),
        );
      }
    }
  }

  void download(Video video) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在下载'),
      ),
    );
    if (_downloadProgress.containsKey(video.id)) {
      return;
    }
    Dio dio = Dio();
    var cacheSavePath = await getApplicationCacheDirectory();
    debugPrint("${cacheSavePath.path}/${video.id}.mp4");
    await dio.download(video.url, "${cacheSavePath.path}/${video.id}.mp4",
        onReceiveProgress: (count, total) {
      setState(() {
        _downloadProgress[video.id] = count / total;
      });
    },
        deleteOnError: true,
        options: Options(responseType: ResponseType.stream));

    GallerySaver.saveVideo("${cacheSavePath.path}/${video.id}.mp4")
        .then((value) => {
          ScaffoldMessenger.of(context).clearSnackBars(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('下载成功: ${video.id}.mp4'),
                ),
              ),
              setState(() {
                _downloadProgress.remove(video.id);
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 筛选
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: widget.videos.isEmpty ? const Center(child: Text("什么都没有哦，录一个看看吧")) :ListView.builder(
              itemCount: widget.videos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      DownloadItem(index),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  ListTile DownloadItem(int index) {
    return ListTile(
                      leading: Text(widget.videos[index].id.toString()),
                      title:
                      Text(widget.videos[index].recordTime.toString()),
                      subtitle: Text("录制机厅：${widget.videos[index].name}"),
                      trailing: _downloadProgress
                          .containsKey(widget.videos[index].id)
                          ? CircularProgressIndicator(
                          value: _downloadProgress[
                          widget.videos[index].id])
                          : IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          saveNetworkVideo(widget.videos[index]);
                        },
                      ),
                    );
  }
}
