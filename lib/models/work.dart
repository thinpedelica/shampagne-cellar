import 'package:flutter/material.dart';

class Work {
  const Work({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.year,
    required this.tags,
    required this.thumbnail,
    this.heroOrder,
    this.videoUrl,
    this.videoId,
    required this.images,
  });

  final String id;
  final String title;
  final String category;
  final String description;
  final int year;
  final List<String> tags;
  final String thumbnail;
  final int? heroOrder;
  final String? videoUrl;
  final String? videoId;
  final List<String> images;

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: _parseDescription(json['description']),
      year: json['year'] is int
          ? json['year'] as int
          : int.tryParse(json['year'].toString()) ?? 0,
      tags: (json['tags'] as List? ?? []).map((t) => t.toString()).toList(),
      thumbnail: json['thumbnail']?.toString() ?? '',
      heroOrder: json['heroOrder'] == null
          ? null
          : (json['heroOrder'] as num).toInt(),
      videoUrl: json['videoUrl']?.toString(),
      videoId: json['videoId']?.toString(),
      images:
          (json['images'] as List? ?? const []).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'year': year,
        'tags': tags,
        'thumbnail': thumbnail,
        if (heroOrder != null) 'heroOrder': heroOrder,
        if (videoUrl != null) 'videoUrl': videoUrl,
        if (videoId != null) 'videoId': videoId,
        'images': images,
      };

  Color get accentColor {
    final hue = id.hashCode % 360;
    return HSVColor.fromAHSV(1, hue.toDouble(), 0.4, 0.95).toColor();
  }
}

String _parseDescription(dynamic value) {
  if (value == null) {
    return '';
  }
  if (value is List) {
    return value.map((e) => e.toString()).join('\n');
  }
  return value.toString();
}
