import 'package:flutter/material.dart';

import '../models/work.dart';
import 'video_embed_view_stub.dart'
    if (dart.library.html) 'video_embed_view_web.dart';

class VideoEmbed extends StatefulWidget {
  const VideoEmbed({super.key, required this.work});

  final Work work;

  @override
  State<VideoEmbed> createState() => _VideoEmbedState();
}

class _VideoEmbedState extends State<VideoEmbed> {
  late String _elementId;

  @override
  void initState() {
    super.initState();
    _elementId = _buildElementId(widget.work.id);
  }

  @override
  void didUpdateWidget(covariant VideoEmbed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.work.id != oldWidget.work.id) {
      disposeVideoEmbed(_elementId);
      setState(() {
        _elementId = _buildElementId(widget.work.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = buildVideoEmbedView(widget.work, _elementId);
    if (content == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        const SizedBox(height: 32),
      ],
    );
  }

  @override
  void dispose() {
    disposeVideoEmbed(_elementId);
    super.dispose();
  }

  String _buildElementId(String workId) =>
      'video-$workId-${DateTime.now().millisecondsSinceEpoch}';
}
