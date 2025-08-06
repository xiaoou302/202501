/// News event model representing a timeline event
class NewsEvent {
  final String title;
  final String timeAgo; // e.g., "2 hours ago"
  final String summary;
  final String impact; // e.g., "High", "Medium", "Low"
  final List<String> affectedPairs; // Trading pairs affected by this news

  // 新增字段
  final String source; // 资讯来源
  final String url; // 资讯链接
  final String imageUrl; // 资讯图片链接
  final Map<String, dynamic>? details; // 详细信息
  final DateTime? publishTime; // 发布时间
  final List<String>? tags; // 标签
  final double? sentiment; // 情绪评分 (0-100)

  const NewsEvent({
    required this.title,
    required this.timeAgo,
    required this.summary,
    required this.impact,
    required this.affectedPairs,
    this.source = '',
    this.url = '',
    this.imageUrl = '',
    this.details,
    this.publishTime,
    this.tags,
    this.sentiment,
  });

  factory NewsEvent.fromJson(Map<String, dynamic> json) {
    return NewsEvent(
      title: json['title'] as String,
      timeAgo: json['timeAgo'] as String,
      summary: json['summary'] as String,
      impact: json['impact'] as String,
      affectedPairs:
          (json['affectedPairs'] as List).map((e) => e as String).toList(),
      source: json['source'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      details: json['details'] as Map<String, dynamic>?,
      publishTime: json['publishTime'] != null
          ? DateTime.parse(json['publishTime'] as String)
          : null,
      tags: json['tags'] != null
          ? (json['tags'] as List).map((e) => e as String).toList()
          : null,
      sentiment: json['sentiment'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'timeAgo': timeAgo,
      'summary': summary,
      'impact': impact,
      'affectedPairs': affectedPairs,
      'source': source,
      'url': url,
      'imageUrl': imageUrl,
      'details': details,
      'publishTime': publishTime?.toIso8601String(),
      'tags': tags,
      'sentiment': sentiment,
    };
  }
}
