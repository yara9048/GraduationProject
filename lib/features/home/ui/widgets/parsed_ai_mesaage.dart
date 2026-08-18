class VideoSegment {
  final double startSeconds;
  final double endSeconds;
  final String startLabel;
  final String endLabel;

  const VideoSegment({
    required this.startSeconds,
    required this.endSeconds,
    required this.startLabel,
    required this.endLabel,
  });
}

class ParsedAiMessage {
  final String answer;
  final List<VideoSegment> segments;

  const ParsedAiMessage({
    required this.answer,
    required this.segments,
  });
}
