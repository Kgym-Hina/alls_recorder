class Video {
  final int id;
  final String card;
  final String url;
  final String downloadCount;
  final DateTime recordTime;
  final int qth;
  final String name;

  Video({
    required this.qth,
    required this.id,
    required this.card,
    required this.url,
    required this.downloadCount,
    required this.recordTime,
    required this.name,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      card: json['card'],
      url: json['url'],
      downloadCount: json['download_count'],
      recordTime: DateTime.parse(json['record_time']),
      qth: json['qth'],
      name: json['name'],
    );
  }
}