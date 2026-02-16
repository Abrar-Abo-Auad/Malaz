import 'package:flutter/material.dart';

class SearchTextHighlighter extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;

  const SearchTextHighlighter({
    required this.text,
    required this.query,
    required this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(text, style: baseStyle);
    }

    final matches = query.toLowerCase().allMatches(text.toLowerCase());
    List<TextSpan> spans = [];
    int start = 0;

    for (var match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start), style: baseStyle));
      }

      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: baseStyle.copyWith(
          color: const Color(0xFF2ECC71),
          fontWeight: FontWeight.w900,
          backgroundColor: const Color(0xFF2ECC71).withOpacity(0.15),
        ),
      ));
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: baseStyle));
    }

    return RichText(text: TextSpan(children: spans));
  }
}