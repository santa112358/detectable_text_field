import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detectable text field sample"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // DetectableText(
              //   text:
              //       "Welcome to #Detectable @TextField this is sample text we are texting the feed text here. Welcome to #Detectable @TextField this is sample text we are texting the feed text here",
              //   detectionRegExp: hashTagAtSignRegExp,
              //   trimLines: 3,
              //   colorClickableText: Colors.pink,
              //   trimMode: TrimMode.Line,
              //   trimCollapsedText: '...Expand',
              //   trimExpandedText: ' Collapse ',
              //   onTap: (tappedText) {
              //     print(tappedText);
              //   },
              // ),
              DetectableText(
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
                onTap: (tappedText) async {
                  print(tappedText);
                  if (tappedText.startsWith('#')) {
                    debugPrint('DetectableText >>>>>>> #');
                  } else if (tappedText.startsWith('@')) {
                    debugPrint('DetectableText >>>>>>> @');
                  } else if (tappedText.startsWith('http')) {
                    debugPrint('DetectableText >>>>>>> http');
                  }
                },
                basicStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                detectedStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 32),
              DetectableTextField(
                maxLines: null,
                detectionRegExp: detectionRegExp(),
                onDetectionTyped: (text) {
                  print(text);
                },
                onDetectionFinished: () {
                  print('finished');
                },
              ),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
