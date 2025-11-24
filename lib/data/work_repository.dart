import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/work.dart';

class WorkRepository {
  static const _manifestPath = 'assets/data/works_manifest.json';

  /// Load works from the bundled JSON asset.
  static Future<List<Work>> loadWorks() async {
    final manifestString = await rootBundle.loadString(_manifestPath);
    final List<dynamic> manifest = jsonDecode(manifestString) as List<dynamic>;
    final List<Work> works = [];
    for (final entry in manifest) {
      final path = entry.toString();
      final jsonString = await rootBundle.loadString(path);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      works.add(Work.fromJson(data));
    }
    return works;
  }

  static Work? findById(List<Work> works, String id) {
    for (final work in works) {
      if (work.id == id) {
        return work;
      }
    }
    return null;
  }

  static List<Work> relatedWorks(List<Work> works, Work current, {int maxItems = 3}) {
    final filtered = works.where((w) => w.id != current.id && w.category == current.category).toList();
    if (filtered.length > maxItems) {
      return filtered.take(maxItems).toList();
    }
    return filtered;
  }

  static Map<String, List<Work>> groupByCategory(List<Work> works) {
    final Map<String, List<Work>> grouped = {};
    for (final work in works) {
      grouped.putIfAbsent(work.category, () => []).add(work);
    }
    return grouped;
  }
}
