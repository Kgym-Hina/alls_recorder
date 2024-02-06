# Arcade Live Linkage System

Arcade Live Linkage System 是与自助录制系统配套的移动端应用程序，用于生成用户的唯一 QR 码并显示与其关联的视频列表

**部分代码由 AI 生成，因此可能存在一些问题，欢迎提交 PR 进行改进**

## Features

- **二维码生成**: 应用程序会随机生成一个用户 ID, 用于给自助录制系统的视频进行标识
- **视频列表**: 自助录制系统上传的视频会显示在应用程序的视频列表中

## Code Structure

- `lib/main.dart`: 应用的入口文件, 负责在各个页面之间进行切换
- `lib/qr_page.dart`: 该文件定义了 `QrPage` 组件, 用于展示用户的唯一二维码
- `lib/sort_bar.dart`: 用于筛选和排序的组件, WIP
- `lib/ios_hint.dart`: 用于提示用户在 iOS 设备上使用 Safari 安装 PWA 应用的组件
- `lib/app_ad.dart`: 在用户使用浏览器访问网站时, 用于提示用户安装 PWA 应用的组件

## Development

安装 Flutter 开发环境, 并运行以下命令启动应用程序

```bash
flutter run
```

## Contributing

欢迎提交 PR, Issue 一同改进本项目~

## License

This project is licensed under the GNU Affero General Public License v3.0. See the LICENSE file for more details.