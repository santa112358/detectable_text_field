import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';

class DetectableTextExample extends StatelessWidget {
  const DetectableTextExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetectableText Example'),
      ),
      body: Center(
        child: DetectableText(
          trimLines: 1,
          colorClickableText: Colors.pink,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'more',
          trimExpandedText: '...less',
          text:
              "Welcome to #Detectable @TextField http://www.google.com this is sample text we are texting the feed text here. Welcome to #Detectable @TextField this is sample text we are texting the feed text here",
          detectionRegExp: RegExp(
            "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegexContent",
            multiLine: true,
          ),
          onExpansionChanged: (bool readMore) {
            debugPrint('Read more >>>>>>> $readMore');
          },
          onTap: (tappedText) async {
            debugPrint(tappedText);
            if (tappedText.startsWith('#')) {
              debugPrint('DetectableText >>>>>>> #');
            } else if (tappedText.startsWith('@')) {
              debugPrint('DetectableText >>>>>>> @');
            } else if (tappedText.startsWith('http')) {
              debugPrint('DetectableText >>>>>>> http');
            }
          },
          basicStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          detectedStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
