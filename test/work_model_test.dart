import 'package:flutter_test/flutter_test.dart';
import 'package:shampagne_cellar/models/work.dart';

void main() {
  test('Work converts to/from JSON', () {
    const payload = {
      'id': 'demo',
      'title': 'Demo Work',
      'category': 'VJ',
      'description': 'A quick demo.',
      'year': 2024,
      'tags': ['demo', 'test'],
      'thumbnail': 'assets/images/demo.webp',
      'heroOrder': 1,
      'videoUrl': 'https://www.youtube.com/watch?v=demo',
      'videoId': 'demoId',
      'images': ['assets/images/demo-1.webp', 'assets/images/demo-2.webp'],
    };

    final work = Work.fromJson(Map<String, dynamic>.from(payload));
    expect(work.id, 'demo');
    expect(work.title, 'Demo Work');
    expect(work.tags.length, 2);

    expect(work.heroOrder, 1);
    expect(work.videoUrl, 'https://www.youtube.com/watch?v=demo');
    expect(work.videoId, 'demoId');
    expect(work.images.length, 2);
    expect(work.toJson(), payload);
  });
}

