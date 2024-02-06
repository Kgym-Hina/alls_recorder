import 'package:flutter/material.dart';

class SortBar extends StatelessWidget {
  final Function onSortByUploadTime;
  final Function onSortById;

  SortBar({required this.onSortByUploadTime, required this.onSortById});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          child: const Text('按上传时间'),
          onPressed: () => onSortByUploadTime(),
        ),
        TextButton(
          child: const Text('按机厅筛选'),
          onPressed: () => onSortById(),
        ),
      ],
    );
  }
}