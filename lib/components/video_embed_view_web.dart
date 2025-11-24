// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

import '../models/work.dart';

Widget? buildVideoEmbedView(Work work, String elementId) {
  final videoId = work.videoId ?? _extractYoutubeId(work.videoUrl);
  if (videoId == null || videoId.isEmpty) {
    return null;
  }
  return _YoutubeEmbed(
    videoId: videoId,
    elementId: elementId,
  );
}

void disposeVideoEmbed(String elementId) {
  html.document.getElementById(elementId)?.remove();
}

class _YoutubeEmbed extends StatefulWidget {
  const _YoutubeEmbed({required this.videoId, required this.elementId});

  final String videoId;
  final String elementId;

  @override
  State<_YoutubeEmbed> createState() => _YoutubeEmbedState();
}

class _YoutubeEmbedState extends State<_YoutubeEmbed> {
  late final String _viewType;
  html.IFrameElement? _iframe;

  @override
  void initState() {
    super.initState();
    _viewType =
        'youtube-embed-${widget.elementId}-${DateTime.now().millisecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..id = widget.elementId
        ..src =
            'https://www.youtube.com/embed/${widget.videoId}?autoplay=1&mute=1&playsinline=1&enablejsapi=1'
        ..style.border = '0'
        ..allow =
            'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
        ..allowFullscreen = true;
      _iframe = iframe;
      return iframe;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), _attemptUnmute);
    });
  }

  void _attemptUnmute() {
    final iframe = _iframe;
    if (iframe?.contentWindow == null) {
      return;
    }
    final win = iframe!.contentWindow!;
    const commands = [
      '{"event":"command","func":"playVideo","args":""}',
      '{"event":"command","func":"unMute","args":""}',
    ];
    for (final cmd in commands) {
      win.postMessage(cmd, '*');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: HtmlElementView(viewType: _viewType),
    );
  }

  @override
  void dispose() {
    final iframe = _iframe;
    if (iframe?.contentWindow != null) {
      iframe!.contentWindow!.postMessage(
        '{"event":"command","func":"stopVideo","args":""}',
        '*',
      );
    }
    super.dispose();
  }
}

String? _extractYoutubeId(String? url) {
  if (url == null || url.isEmpty) {
    return null;
  }
  if (url.contains('watch?v=')) {
    return url.split('watch?v=').last.split('&').first;
  }
  if (url.contains('youtu.be/')) {
    return url.split('youtu.be/').last.split('?').first;
  }
  if (url.contains('embed/')) {
    return url.split('embed/').last.split('?').first;
  }
  return null;
}
